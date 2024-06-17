# gnh1201/mastodon-lingva
# Namhyeon Go <abuse@catswords.net>
# https://github.com/gnh1201/mastodon-lingva
import traceback
import json
import re
from flask import Flask, request, jsonify
from pylingva import pylingva

app = Flask(__name__)

trans = pylingva("https://translate.catswords.net")

HTML_TAGS_PATTERN = re.compile('<.*?>')
URL_PATTERN = re.compile(r'http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+')

# do translate
@app.route('/translate', methods=['POST'])
def translate():
    original_texts = []

    # from HTML FormData
    data = request.form.to_dict()
    if 'q' in data:
        original_texts.append(data['q'])

    # from JSON request
    try:
       jsondata = json.loads(request.data)
       if 'q' in jsondata and 'target' in jsondata:
           data.update({
               "q": jsondata['q'],
               "source": jsondata['source'] if 'source' in jsondata else 'auto',
               "target": jsondata['target']
           })
           for text in data['q']:
               if text:
                   original_texts.append(text)
    except Exception as e:
        traceback.print_exc()
        app.logger.info(str(e))
        #return jsonify({"error": str(e)}), 500

    # check required parameters
    if 'q' not in data or 'target' not in data:
        return jsonify({"error": "Missing required parameters"}), 400

    # set a source language
    #from_language = data['source'] if 'source' in data else 'auto'
    from_language = 'auto'

    # translate it
    try:
        translated_texts = []
        for text in original_texts:
            text = re.sub(HTML_TAGS_PATTERN, '', text)
            text = re.sub(URL_PATTERN, '', text)
            if text:
                #print ("Original text:", text)
                translated_texts.append(trans.translate(from_language, data['target'], text))
        return jsonify({"translatedText": translated_texts}), 200
    except Exception as e:
        traceback.print_exc()
        app.logger.info(str(e))
        #return jsonify({"error": str(e)}), 500

# get a list of supported languages
@app.route('/languages', methods=['GET'])
def get_languages():
    try:
        list_languages = trans.languages()
        list_languages.pop('Detect', None)

        supported_languages = []
        for name, code in list_languages.items():
            supported_languages.append({
                "code": code,
                "name": name,
                "targets": list(list_languages.values())
            })

        return jsonify(supported_languages), 200
    except Exception as e:
        traceback.print_exc()
        app.logger.info(str(e))
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(host='0.0.0.0', debug=True)
