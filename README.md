# ChatGemini

## Introduction :-

A Flutter project that enables you to access the Gemini API from a Flutter application. This application already has an API Key embedded within it but a custom one can also be added if required.
In order to use ChatGemini with your own API Key, you need to get an API Key from [aistudio.google.com](https://aistudio.google.com/).
Once you have the key, you can paste it in the profile section of the application and start writing prompts from within the application.


# Demo


https://github.com/darshmashru/ChatGemini/assets/70889682/36d69a03-cb1f-4e3b-93c9-4ad5edaf0e4a






## Deployment

To run this project we have to first create a .env file in the root directory

```bash
  git clone https://github.com/darshmashru/ChatPaLM.git
```

```bash
  touch .env
```

Add Your Enviornment Variables 

| Parameter | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `PALM_API_KEY` | `string` | **Required**. Your API key |
| `FIREBASE_WEB` | `string` | **Required**. Your Firebase Web API key |
| `FIREBASE_IOS` | `string` | **Required**. Your Firebase IOS API key |
| `FIREBASE_ANDROID` | `string` | **Required**. Your Firebase Android API key |
| `FIREBASE_MACOS` | `string` | **Required**. Your Firebase MACOS API key |

Your final file would look like 
```bash
PALM_API_KEY = YOUR_API_KEY
FIREBASE_WEB = YOUR_API_KEY
FIREBASE_ANDROID = YOUR_API_KEY
FIREBASE_IOS = YOUR_API_KEY
FIREBASE_MACOS = YOUR_API_KEY
```


Finally , To Run The Application

```bash
Flutter Run
```



## Screenshots

<div align="center">
  <img src="https://chatgeminidata.s3.eu-north-1.amazonaws.com/chatgemin_data/Screenshot+2024-03-02+at+1.47.33%E2%80%AFPM.png" alt="Screenshot 1" width="200"/>
  <img src="https://chatgeminidata.s3.eu-north-1.amazonaws.com/chatgemin_data/Screenshot+2024-03-02+at+1.48.16%E2%80%AFPM.png" alt="Screenshot 2" width="200"/>
</div>

<div align="center">
  <img src="https://chatgeminidata.s3.eu-north-1.amazonaws.com/chatgemin_data/Screenshot+2024-03-02+at+1.48.23%E2%80%AFPM.png" alt="Screenshot 3" width="200"/>
  <img src="https://chatgeminidata.s3.eu-north-1.amazonaws.com/chatgemin_data/Screenshot+2024-03-02+at+1.48.43%E2%80%AFPM.png" alt="Screenshot 4" width="200"/>
</div>



## Authors

- [@darshmashru](https://www.github.com/darshmashru)
- [@prabirkalwani](https://www.github.com/prabirkalwani)
- [@vedantheda](https://www.github.com/vedantheda)

