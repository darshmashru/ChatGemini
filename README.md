# ChatPaLM


https://github.com/darshmashru/ChatPaLM/assets/70889682/f75debcf-6c8e-4e64-87d6-19391996e9b9


## Introduction :-

A Flutter project that enables you to access the PaLM API from a Flutter application. In order to use ChatPaLM, you need to get an API Key from makersuite.google.com.
Once you have the key, you can paste it in the profile section of the application and start writing prompts from within the application.

## API Reference

#### SET UP YOUR ENVIORNMENT VARIABLES

Create a .env file in the project root when you clone this repo and insert
the following:-

```http
touch .env
```

```http
vim .env
```

| Parameter      | Type     | Description                               |
| :------------- | :------- | :---------------------------------------- |
| `PALM_API_KEY` | `string` | **Required**. Your API key For PaLM Model |

| Parameter      | Type     | Description                             |
| :------------- | :------- | :-------------------------------------- |
| `FIREBASE_WEB` | `string` | **Required**. API Key For Firebase Auth |

| Parameter      | Type     | Description                             |
| :------------- | :------- | :-------------------------------------- |
| `FIREBASE_IOS` | `string` | **Required**. API Key For Firebase Auth |

| Parameter        | Type     | Description                             |
| :--------------- | :------- | :-------------------------------------- |
| `FIREBASE_MACOS` | `string` | **Required**. API Key For Firebase Auth |

| Parameter          | Type     | Description                             |
| :----------------- | :------- | :-------------------------------------- |
| `FIREBASE_ANDROID` | `string` | **Required**. API Key For Firebase Auth |

Your Final File Would Look Like :-

```http
PALM_API_KEY = YOUR_API_KEY

FIREBASE_WEB = YOUR_API_KEY

FIREBASE_ANDROID = YOUR_API_KEY

FIREBASE_IOS = YOUR_API_KEY

FIREBASE_MACOS = YOUR_API_KEY

```

## Demonstration
<div style="display: flex; justify-content: space-around;">
  <img width="323" alt="Main_Page" src="https://github.com/darshmashru/ChatPaLM/assets/70889682/3f768931-9aef-46d2-b655-c4b84c2e25fc">
  <img width="323" alt="AuthPage" src="https://github.com/darshmashru/ChatPaLM/assets/70889682/ea68f010-3065-4c04-b65e-992efc46110f">
  <img width="323" alt="ProfilePage" src="https://github.com/darshmashru/ChatPaLM/assets/70889682/0c2c9a29-89bb-468b-8e13-06b1aa75cf91">
</div>


## Authors

- [@Darsh Mashru](https://www.github.com/darshmashru)
- [@Prabir Kalwani](https://www.github.com/prabirkalwani)
