#Note: The openai-python library support for Azure OpenAI is in preview.
      #Note: This code sample requires OpenAI Python library version 1.0.0 or higher.
import os
from openai import AzureOpenAI

def get_aoai_response(system_prompt: str, prompt: str):
    client = AzureOpenAI(
        azure_endpoint = os.getenv("AZURE_OPENAI_ENDPOINT"),
        api_key = os.getenv("AZURE_OPENAI_KEY"),  
        api_version = os.getenv("AZURE_OPENAI_API_VERSION")
        )


    message_text = [{"role":"system","content":system_prompt},{"role":"user","content":prompt}]

    completion = client.chat.completions.create(
        model="gpt-4-32k", # model = "deployment_name"
        messages = message_text,
        temperature=0.7,
        max_tokens=800,
        top_p=0.95,
        frequency_penalty=0,
        presence_penalty=0,
        stop=None
    )
    # print(type(completion))
    # print(dir(completion))
    # print(completion.choices)
    # print(type(completion.choices[0]))
    # print(dir(completion.choices[0]))
    # print(type(completion.choices[0].message))
    # print(dir(completion.choices[0].message))
    
    try:
        answer = completion.choices[0].message.content
    except Exception as e:
        answer = f"No response available, please try again. {e}"
    
    return answer


