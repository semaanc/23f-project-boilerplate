from flask import Blueprint, request, jsonify, make_response
import json
from src import db


departments = Blueprint('departments', __name__)
