from flask import Blueprint, request, jsonify, make_response
import json
from src import db


classes = Blueprint('classes', __name__)
