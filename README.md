# mastodon-lingva
Lingva Translate Gateway for Mastodon (LibreTranslate API compatible)

## Quick start
1. Install `flask`
   ```
   pip install flask
   ```

2. Install the modified `pylingva`
   ```
   git clone https://git.catswords.net/gnh1201/pylingva && cd pylingva
   pip install .
   ```

3. Add lines to `.env.production`
   ```
   LIBRE_TRANSLATE_ENDPOINT=https://translation-api.catswords.net   # YOUR API URL
   LIBRE_TRANSLATE_API_KEY=true
   ```

3. Run mastodon-lingva
   ```
   python3 server.py &
   ```

4. Restart all related processes

## How to test?

### HTML FormData

```bash
curl -X POST -H "Content-Type: application/x-www-form-urlencoded" -d 'q=hello world&source=en&target=ko' http://localhost:5000/translate
```

### JSON
```bash
curl -X POST -H "Content-Type: application/json" -d '{"q":["hello world"],"source":"en","target":"ko"}' http://localhost:5000/translate
```

## Requirements
* pylingva (modified version): https://git.catswords.net/gnh1201/pylingva
* Lingva Translate: https://github.com/thedaviddelta/lingva-translate

## Contact me
* ActivityPub [@gnh1201@catswords.social](https://catswords.social/@gnh1201)
* abuse@catswords.net
