import logging
import os

from Controllers.HealthController import blp as HealthBlueprint
from dotenv import dotenv_values
from flask import Flask
from waitress import serve


def create_app():
    app = Flask(__name__)

    variaveis_de_ambiente = {
        **dotenv_values(".env.development"),
        **os.environ,
    }

    app.config.update(variaveis_de_ambiente)

    app.register_blueprint(HealthBlueprint)

    logging.basicConfig(level=logging.DEBUG)

    return app


if __name__ == "__main__":
    app = create_app()
    serve(app, host="0.0.0.0", port=80)
