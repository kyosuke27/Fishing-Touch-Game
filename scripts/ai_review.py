import os
from pathlib import Path
from datetime import datetime
from openai import OpenAI

# プロジェクトルートと入出力ファイルの場所を固定し、実行場所に依存しないようにする。
ROOT = Path(__file__).resolve().parent.parent
TEMPLATE_PATH = Path(__file__).resolve().parent / "templates"
README_PATH = ROOT / "README.md"
OUTPUT_DIR = ROOT / "docs" / "review"
LATEST_OUTPUT = OUTPUT_DIR / "latest.md"
GPT_MODEL = os.environ["OPENAI_MODEL"]
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

    response = client.responses.create(
        model=GPT_MODEL,
        input=prompt,
    )

    return response.output_text


def save_report(report: str) -> None:
    """生成された機能提案レポートを最新ファイルと日時付きファイルへ保存する。

    Args:
        report: AIが生成した機能提案本文。

    Returns:
        None
    """
    # 初回実行でも保存に失敗しないよう、出力先ディレクトリを先に作成する。
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

    now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    # 生成日時と参照元を付与し、後からレポートの前提を追いやすくする。
    final_report = f"""# AI Feature Proposal

Generated at: {now}

Source:
- README.md

---

{report}
"""

    LATEST_OUTPUT.write_text(final_report, encoding="utf-8")

    # latest.mdとは別に履歴ファイルを残し、過去の提案と比較できるようにする。
    dated_output = OUTPUT_DIR / f"{datetime.now().strftime('%Y-%m-%d-%H%M')}-feature-proposal.md"
    dated_output.write_text(final_report, encoding="utf-8")
    
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
    readme = load_readme()
    output_format = read_template(OUTPUT_FORMAT_TEMPLATE_NAME)
    prompt = build_prompt(readme, output_format)
    report = analyze(prompt)
    save_report(report)

    print("✅ AI feature proposal completed.")


if __name__ == "__main__":
    main()
