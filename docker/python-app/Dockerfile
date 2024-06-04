FROM python:3.6

WORKDIR /app

COPY src/. ./

RUN pip install -r requirements.txt

EXPOSE 3002

CMD [ "python", "server.py" ]

# docker run -d --name pythonapp_nautilus -p 8095:3002  nautilus/python-app:latest