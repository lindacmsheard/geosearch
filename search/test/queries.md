```
    {
      "@search.score": 1,
      "age_range": "10-17",
      "outcome": "Arrest",
      "involved_person": true,
      "self_defined_ethnicity": "Asian/Asian British - Pakistani",
      "gender": "Male",
      "legislation": "Police and Criminal Evidence Act 1984 (section 1)",
      "outcome_linked_to_object_of_search": true,
      "datetime": "2024-01-28T17:55:05Z",
      "operation": false,
      "officer_defined_ethnicity": "Asian",
      "type": "Person search",
      "object_of_search": "Stolen goods",
      "AzureSearch_DocumentKey": "aHR0cHM6Ly9henVyZWxha2VzdG9yYWdlMzM3LmJsb2IuY29yZS53aW5kb3dzLm5ldC9zYW1wbGVkYXRhL2pzb25sL3BvbGljZV9zdG9wc193ZXN0LW1lcmNpYV8yMDI0LTAxLmpzb25sOzY1",
      "outcome_object": {
        "id": "bu-arrest",
        "name": "Arrest"
      }
    }
```



```
{
  "search": "*",
  "count": true
}
```

https://learn.microsoft.com/en-us/azure/search/search-faceted-navigation#facet-request-and-response


2 . facet by operation, and show only outcome
```
{
    "search": "*",
    "queryType": "simple",
    "select": "outcome",
    "searchFields": "",
    "filter": "",
    "facets": [ "operation"], 
    "orderby": "",
    "count": true
}
```

3. 
{
    "search": "*",
    "queryType": "simple",
    "select": "object_of_search, outcome",
    "searchFields": "",
    "filter": "operation eq true",
    "facets": [ "age_range"], 
    "orderby": "",
    "count": true
}
