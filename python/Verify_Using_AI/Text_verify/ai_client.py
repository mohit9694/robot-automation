import json
import requests
from pathlib import Path

OLLAMA_URL = "http://host.docker.internal:11434/api/chat"
MODEL = "llama3.2"

INPUT_FILE = Path("python/Verify_Using_AI/Text_verify/input_text.txt")
OUTPUT_FILE = Path("python/Verify_Using_AI/Text_verify/output_report.json")
expected_language = 'English'

def main():
    # Read webpage text
    page_text = INPUT_FILE.read_text(encoding="utf-8")

    # Prompt for the LLM
    prompt = f"""
            You are a JSON-only text correction engine.

            Expected language: {expected_language}
            Text to correct:
            {page_text}
            Your ONLY task:
            - Translate text that is not in the expected language.
            - Fix spelling mistakes.
            - Fix obvious grammar mistakes.
            - Preserve the original meaning.
            - Do not explain anything.
            Return ONLY one JSON object.
            """

    # Send request to Ollama
    response = requests.post(
    OLLAMA_URL,
    json={
        "model": "llama3.2",
        "messages": [
            {
                "role": "user",
                "content": prompt
            }
        ],
        "stream": False,
        "format": "json"
    },
    timeout=300
    )

    response.raise_for_status()

    result = response.json()
    
    # Extract AI response
    ai_text = result["message"]["content"]

    # Save result
    OUTPUT_FILE.parent.mkdir(parents=True, exist_ok=True)

    OUTPUT_FILE.write_text(
        json.dumps(
            {
                "model": MODEL,
                "response": ai_text
            },
            indent=4,
            ensure_ascii=False
        ),
        encoding="utf-8"
    )

    print("AI analysis completed.")
    print(f"Output saved to: {OUTPUT_FILE}")


if __name__ == "__main__":
    main()