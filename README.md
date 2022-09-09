# README

This project implements API to create and authenticate users.

* Creating a new user
```
POST api/v1/registrations

{
    "user": {
        "username": "Test user",
        "password": "123",
        "password_confirmation": "123"
    }
}

```

* Log in an user
```
POST api/v1/sessions

{
    "username": "Test user",
    "password": "123"   
}

```

* All the user data are persisted on Redis.

* To boot up Redis, use this command `docker compose up`
