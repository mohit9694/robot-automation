*** Settings ***
Library    Browser
Library    OperatingSystem


*** Test Cases ***
Analyze Web Page

    New Browser    chromium    headless=True
    New Page    https://www.eviltester.com/post/applications-to-practice-testing-and-automating/

    ${page_text}=    Get Text    css=body

    Create File    python/Verify_Using_AI/Text_verify/input_text.txt    ${page_text}
    Run    python/Verify_Using_AI/Text_verify/ai_client.py
    Close Browser
