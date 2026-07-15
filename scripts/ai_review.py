import os
import json
from pathlib import Path
from datetime import datetime
from openai import OpenAI

# プロジェクトルートと入出力ファイルの場所を固定し、実行場所に依存しないようにする。
ROOT = Path(__file__).resolve().parent.parent
TEMPLATE_PATH = Path(__file__).resolve().parent / "templates"
README_PATH = ROOT / "README.md"
OUTPUT_DIR = ROOT / "docs" / "review"
# Issue作成スクリプトはJSONを読む想定なので、機械処理用の最新ファイルを固定名で保存する。
LATEST_JSON_OUTPUT = OUTPUT_DIR / "latest.json"
# 人間が内容を確認しやすいように、同じ内容をMarkdownにも変換して保存する。
LATEST_MARKDOWN_OUTPUT = OUTPUT_DIR / "latest.md"
# 利用するモデルはGitHub Actionsやローカル実行時に切り替えられるよう、環境変数から取得する。
GPT_MODEL = os.environ["OPENAI_MODEL"]
# テンプレート名を定数化し、ファイル名変更時の修正漏れを防ぐ。
PROMPT_TEMPLATE_NAME = "prompt_template.txt"
OUTPUT_FORMAT_TEMPLATE_NAME = "feature_proposal_output_format.txt"


def load_readme() -> str:
    """README.mdを読み込む。

    Returns:
        str: README.mdの本文。

    Raises:
        FileNotFoundError: README.mdが存在しない場合。
    """
    if not README_PATH.exists():
        raise FileNotFoundError("README.md が見つかりません。")

    # 文字化けや一部の不正文字で処理全体が止まらないよう、読み込み時は不正文字を無視する。
    return README_PATH.read_text(encoding="utf-8", errors="ignore")


def build_prompt(readme: str, output_format: str) -> str:
    """READMEをもとにAIへ渡す機能提案用プロンプトを組み立てる。

    Args:
        readme: README.mdの本文。
        output_format: AIの回答形式を指定するテンプレート本文。

    Returns:
        str: OpenAI APIへ送信するプロンプト。
    """
    # prompt_template.txtは「依頼内容」、output_formatは「回答形式」を担当する。
    # 2つを分けることで、Issue化用JSONの構造だけを後から調整しやすくする。
    return read_template(PROMPT_TEMPLATE_NAME).format(
        output_format=output_format,
        readme=readme,
    )


def analyze(prompt: str) -> str:
    """OpenAI APIでREADME由来の機能提案を生成する。

    Args:
        prompt: 機能提案を生成するためのプロンプト。

    Returns:
        str: AIが生成した機能提案本文。
    """
    # APIキーはコードに埋め込まず、実行環境の環境変数から取得する。
    client = OpenAI(api_key=os.environ["OPENAI_API_KEY"])

    # Responses APIへプロンプトを渡し、READMEをもとにした機能提案JSONを生成する。
    response = client.responses.create(
        model=GPT_MODEL,
        input=prompt,
    )

    return response.output_text


def parse_json_report(report: str) -> dict:
    """AIが返したJSON文字列を辞書に変換する。

    Args:
        report: AIが生成したJSON文字列。

    Returns:
        dict: 機能提案レポート。

    Raises:
        ValueError: JSONとして解析できない場合。
    """
    # 念のため前後の空白や改行を除去し、json.loadsへ渡せる形に近づける。
    normalized_report = report.strip()

    # プロンプトでは「JSONだけ」を指示しているが、モデルが以下のようなMarkdownコードブロックで返す場合がある。
    #
    # ```json
    # { "title": "AI機能提案" }
    # ```
    #
    # json.loadsは```jsonや```を含む文字列を解析できないため、外側の囲みだけを取り除く。
    if normalized_report.startswith("```"):
        # 先頭の```json、または言語指定なしの```を削除する。
        normalized_report = normalized_report.removeprefix("```json").removeprefix("```").strip()
        # 末尾の```を削除し、残ったJSON本体だけにする。
        normalized_report = normalized_report.removesuffix("```").strip()

    try:
        # ここでJSONとして解析できない場合は、後続のIssue作成処理に渡す前に失敗させる。
        return json.loads(normalized_report)
    except json.JSONDecodeError as error:
        raise ValueError("AIの出力をJSONとして解析できませんでした。") from error


def save_report(report: str) -> None:
    """生成された機能提案レポートをJSONと確認用Markdownへ保存する。

    Args:
        report: AIが生成したJSON文字列。

    Returns:
        None
    """
    # 初回実行でも保存に失敗しないよう、出力先ディレクトリを先に作成する。
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

    now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    # AIの生出力をそのまま保存せず、JSONとして解析できることを確認してから扱う。
    report_data = parse_json_report(report)

    # 生成日時と参照元を付与し、Issue作成スクリプト側で前提情報も参照できるようにする。
    final_report = {
        "generatedAt": now,
        # どの入力元から提案を作ったかを残す。将来README以外の仕様書を入力に含めた時の追跡に使う。
        "source": "README.md",
        # どのモデルで生成したかを残す。モデル変更後に提案内容やJSON安定性を比較しやすくする。
        "model": GPT_MODEL,
        "proposal": report_data,
    }

    # JSONはIssue作成スクリプト用、Markdownは人間のレビュー用として同じ内容から生成する。
    # これにより、Markdownの見た目を変えてもIssue作成用JSONの構造を壊さずに済む。
    json_report = json.dumps(final_report, ensure_ascii=False, indent=2)
    markdown_report = build_markdown_report(final_report)

    # latest.*は常に最新結果へ上書きし、GitHub Actionsや手元確認で参照しやすくする。
    LATEST_JSON_OUTPUT.write_text(json_report, encoding="utf-8")
    LATEST_MARKDOWN_OUTPUT.write_text(markdown_report, encoding="utf-8")

    # latestとは別に履歴ファイルを残し、過去の提案と比較できるようにする。
    dated_prefix = OUTPUT_DIR / f"{datetime.now().strftime('%Y-%m-%d-%H%M')}-feature-proposal"
    dated_prefix.with_suffix(".json").write_text(json_report, encoding="utf-8")
    dated_prefix.with_suffix(".md").write_text(markdown_report, encoding="utf-8")


def build_markdown_report(final_report: dict) -> str:
    """JSONレポートから人間が確認しやすいMarkdownを生成する。

    Args:
        final_report: メタ情報とAI提案を含むレポート辞書。

    Returns:
        str: 確認用Markdown本文。
    """
    proposal = final_report["proposal"]

    # Markdownは文字列連結ではなく配列へ行単位で積み上げる。
    # セクション追加や空行調整がしやすく、長いテンプレート文字列より差分も追いやすい。
    lines = [
        f"# {proposal.get('title', 'AI機能提案')}",
        "",
        f"Generated at: {final_report['generatedAt']}",
        f"Source: {final_report['source']}",
        f"Model: {final_report['model']}",
        "",
        "## アプリ理解",
        "",
    ]

    # アプリ理解は短い箇条書きとして表示し、レビュー時に前提をすぐ確認できるようにする。
    for item in proposal.get("appUnderstanding", []):
        lines.append(f"- {item}")

    lines.extend(["", "## 選択方法", ""])
    selection_guide = proposal.get("selectionGuide", {})
    description = selection_guide.get("description")
    if description:
        # IssueNoを使った選択方法を明示し、次のcreate-selected-issues workflowにつなげやすくする。
        lines.append(description)
        lines.append("")

    examples = selection_guide.get("examples", [])
    if examples:
        lines.append("例:")
        for example in examples:
            lines.append(f"- `{example}`")
        lines.append("")

    lines.extend(["## 提案Issue一覧", ""])
    for issue in proposal.get("issues", []):
        # JSONではラベルを配列として保持し、Markdownでは人間が読みやすいカンマ区切りに変換する。
        labels = ", ".join(issue.get("suggestedLabels", []))

        # Issue作成時に必要になる主要情報を、確認用Markdownでも同じ順序で表示する。
        lines.extend(
            [
                f"### {issue.get('issueNo')}: {issue.get('featureName')}",
                "",
                f"- [ ] 選択: {issue.get('issueNo')}",
                f"- 概要: {issue.get('summary')}",
                f"- 実装難易度: {issue.get('implementationDifficulty')}",
                f"- 優先度: {issue.get('priority')}",
                f"- 想定工数: {issue.get('estimatedScope')}",
                f"- Issueタイトル案: {issue.get('suggestedIssueTitle')}",
                f"- ラベル案: {labels}",
                "",
                "#### 課題",
                issue.get("problem", ""),
                "",
                "#### 提案内容",
                issue.get("proposal", ""),
                "",
                "#### ユーザー価値",
                issue.get("userValue", ""),
                "",
                "#### 受け入れ条件",
            ]
        )

        # 受け入れ条件はIssue本文へ流用しやすいように箇条書きで出す。
        for criterion in issue.get("acceptanceCriteria", []):
            lines.append(f"- {criterion}")

        lines.extend(["", "#### 実装メモ"])
        # 実装メモは詳細設計前の補助情報として扱うため、受け入れ条件とは分けて表示する。
        for note in issue.get("implementationNotes", []):
            lines.append(f"- {note}")

        lines.append("")

    lines.extend(["## 優先順位", ""])
    # 優先順位はIssueNoで参照できるようにし、ユーザーが作成対象を指定しやすくする。
    for item in proposal.get("priorityRanking", []):
        lines.append(f"{item.get('rank')}. {item.get('issueNo')}: {item.get('reason')}")

    lines.extend(["", "## 今回は見送る案", ""])
    # Deferred案はIssue化対象外だが、後から再検討できるよう確認用Markdownに残す。
    for idea in proposal.get("deferredIdeas", []):
        lines.append(f"- {idea}")

    command_example = proposal.get("issueCreationCommandExample")
    if command_example:
        # 最後に入力例を出し、workflow_dispatchや後続スクリプトへ渡す値を迷わないようにする。
        lines.extend(
            [
                "",
                "## Issue作成コマンド例",
                "",
                "```text",
                command_example,
                "```",
            ]
        )

    return "\n".join(lines).rstrip() + "\n"
    
def read_template(template_name: str) -> str:
    """指定されたテンプレートファイルを読み込む。

    Args:
        template_name: `scripts/templates`配下のテンプレートファイル名。

    Returns:
        str: テンプレート本文。

    Raises:
        FileNotFoundError: テンプレートファイルが存在しない場合。
    """
    template_file_path = TEMPLATE_PATH / template_name
    if not template_file_path.exists():
        raise FileNotFoundError(f"💣 Template file '{template_name}' not found in '{TEMPLATE_PATH}'")
    else:
        return template_file_path.read_text(encoding="utf-8", errors="ignore")


def main() -> None:
    """READMEの読み込みからAI分析、レポート保存までを順番に実行する。

    Returns:
        None
    """
    print(f"🤖 GPT Model: {GPT_MODEL}")

    # 1. READMEを読み込む。
    readme = load_readme()

    # 2. AIに守ってほしいJSON出力形式を読み込む。
    output_format = read_template(OUTPUT_FORMAT_TEMPLATE_NAME)

    # 3. README本文と出力形式を合成し、OpenAI APIへ渡す最終プロンプトを作る。
    prompt = build_prompt(readme, output_format)

    # 4. AIに機能提案を生成させる。
    report = analyze(prompt)

    # 5. JSONとして検証し、Issue作成用JSONと確認用Markdownへ保存する。
    save_report(report)

    print("✅ AI feature proposal completed.")


if __name__ == "__main__":
    main()
