from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db


department_administrators = Blueprint('department_administrators', __name__)