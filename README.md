#Election Money Loader

A very quick script that takes the data from [Election Money](http://electionmoney.org/) and loads it into a postgres database.

##How to run it
You'll need some Python. Highly recommend running this from a virtual environment.

First, load the requirements. The main one is the awesome csvkit, and also psycopg2 to connect to postgres.

```
pip install -r requirements.txt
```

You can edit lines 12 and 13 to name your database. You will need to edit lines 21 and 24 to connect to your postgres server (unless your username is chris and you're connecting to your local host). It's all sqlalchemy, so check their docs for more info.

Create a new directory to hold your project. Move there and then run the bash script to start everything going. It can take a very long time.

```
mkdir electionmoney
cd electionmoney

sh build.sh
```