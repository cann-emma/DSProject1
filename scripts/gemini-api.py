
import google.generativeai as genai
import numpy as np
import pandas as pd

topics= pd.read_csv("ts_topics.csv")
topics

genai.configure(api_key= GOOGLE_API_KEY)
model = genai.GenerativeModel(model_name="gemini-1.5-flash")

topics_str= topics.to_string()
print(topics_str)

response = model.generate_content(["What theme or category best describes each topic in this dataframe? What specific emotions or subjects are these themes related to?", topics_str])
print(response.text)
