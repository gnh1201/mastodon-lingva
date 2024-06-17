# mastodon-lingva
Lingva Translate Gateway for Mastodon (LibreTranslate API compatible)

## Quick start
1 Install the modified `pylingva`
  ```
  git clone https://git.catswords.net/gnh1201/pylingva && cd pylingva
  pip install .
  ```

2. Add lines to .env.production
  ```
  LIBRE_TRANSLATE_ENDPOINT=https://translation-api.catswords.net   # YOUR API URL
  LIBRE_TRANSLATE_API_KEY=true
  ```

3. Restart all related processes

## Requirements
* pylingva (modified version): https://git.catswords.net/gnh1201/pylingva
* Lingva Translate: https://github.com/thedaviddelta/lingva-translate

## Contact me
* ActivityPub [@gnh1201@catswords.social](https://catswords.social/@gnh1201)
* abuse@catswords.net
