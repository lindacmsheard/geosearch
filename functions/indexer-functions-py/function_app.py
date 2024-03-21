import azure.functions as func
import datetime
import json
import os
import logging
import aoai

app = func.FunctionApp()

@app.route(route="samplefunction", auth_level=func.AuthLevel.ANONYMOUS)
def samplefunction(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')

    # POST request (no req.params)
    name = req.params.get('name')
    if not name:
        try:
            req_body = req.get_json()
        except ValueError:
            pass
        else:
            name = req_body.get('name')

    # GET Request
    if name:
        return func.HttpResponse(f"Hello, {name}. This HTTP triggered function executed successfully.")
    else:
        return func.HttpResponse(
             f"This HTTP triggered function executed successfully. Pass a name in the query string or in the request body for a personalized response. Received {req.body}",
             status_code=200
        )   
    

@app.route(route="aoai_chat", auth_level=func.AuthLevel.ANONYMOUS)
def aoai_chat(req: func.HttpRequest) -> func.HttpResponse:
    """
    This function expects a POST request with a JSON body containing a prompt and an item with attributes:
    {
        "system_prompt": "system prompt for the AI"
        "question": "instruction or question for the AI",
        "context": "context for the AI",
    }

    """
    req_body = req.get_json()
    if req_body:
        # assemble the prompt
        sys_prompt: str = f"{req_body.get('system_prompt')}"
        prompt: str = f"""    
{req_body.get('question')} 
                    
{req_body.get('context')} """

        print(prompt)
        if prompt:
            answer = aoai.get_aoai_response(sys_prompt, prompt)
            return func.HttpResponse(answer)
        else:
            return func.HttpResponse(
                "Please pass a prompt in the request body",
                status_code=400
            )
    else:
        return func.HttpResponse(
            "Please pass a prompt in the request body",
            status_code=200
        )

  

@app.route(route="path_insights_oai", auth_level=func.AuthLevel.ANONYMOUS)
def path_insights_oai(req: func.HttpRequest) -> func.HttpResponse:
    """
    This function expects a POST request with a JSON body containing a prompt and an item with attributes:
    {
    "values": [
      {
        "recordId": "0",
        "data":
           {
             "path": "a/path/to/file",
             "other": "es",
             "phraseList": ["Este", "Inglés"]
           }
      },
      ...
      ]
    }

    """
    print('running path_insights_oai')
    system_prompt = "Return responses only in valid json format, do not include other text. Return dates in iso format (YYYY-mm-DD). Where month or day are not available, use 01. Feel free to add additional metadata if you understand it."
    question = """
    You will be given a series of items in the printed json object below. 
    Items represent data associated with flooding events. 
    Attempt to enrich the items as follows: using the information for the data object for each item, attempt to populate additional attributes into the data object for each item: 'year', 'from_date', 'to_date', 'river', 'location'."""

    req_body = req.get_json()

    if req_body:
        # assemble the prompt
        items = req_body.get('values')

        prompt: str = f"""    
{question} 

{json.dumps(items)}

"""
                    
        print(prompt)
        if prompt:
            answer = aoai.get_aoai_response(system_prompt, prompt)
            return func.HttpResponse(answer)
        else:
            return func.HttpResponse(
                "Please pass a prompt in the request body",
                status_code=400
            )
    else:
        return func.HttpResponse(
            "Please pass a prompt in the request body",
            status_code=200
        )



