from flask import Blueprint, request, jsonify, make_response
import json
from src import db


notes = Blueprint('notes', __name__)
