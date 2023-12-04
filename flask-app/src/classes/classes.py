from flask import Blueprint, request, jsonify, make_response
import json
from src import db

classes = Blueprint('classes', __name__)

# View all classes
@classes.route('/classes', methods=['GET'])
def get_all_classes():
    
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Classes')
    row_headers = [x[0] for x in cursor.description]
    classes_data = cursor.fetchall()

    json_data = []
    for cls in classes_data:
        json_data.append(dict(zip(row_headers, cls)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

@classes.route('/classes', methods=['POST'])
def create_class():
    TODO


# View a specific class
@classes.route('/classes/<class_id>', methods=['GET'])
def view_specific_class(class_id):

# View all the class’s folders
@classes.route('/classes/<class_id>/classfolders', methods=['GET'])
def get_class_folders(class_id):

# Create a new class folder
@classes.route('/classes/<class_id>/classfolders', methods=['POST'])
def create_class_folder(class_id):

@classes.route('/classes/<class_id>/classfolders/<classf_id>', methods=['GET'])
def get_class_folder(classf_id):


@classes.route('/classes/<class_id>/classfolders/<classf_id>', methods=['POST'])
def create_class_folder(classf_id):

@classes.route('/classes/<class_id>/students', methods=['GET'])
def view_students_in_class(class_id):

@classes.route('/classes/<class_id>/students', methods=['POST'])
def add_student_to_class(class_id):

@classes.route('/classes/<class_id>/students/<student_id>', methods=['DELETE'])
def remove_student_from_class(class_id):

@classes.route('/classes/<class_id>/oh/<ta_id>', methods=['GET'])
def get_ta_oh(class_id, ta_id):

@classes.route('/classes/<class_id>/oh/<ta_id>', methods=['POST'])
def add_ta_oh(class_id, ta_id):

@classes.route('/classes/<class_id>/oh/<ta_id>', methods=['REMOVE'])
def remove_ta_oh(class_id, ta_id):

@classes.route('classes/<class_id>/classfolders/<classf_id>/notes/pinned', methods=['GET'])
def view_pinned_note(class_id, ta_id):

@classes.route('classes/<class_id>/classfolders/<classf_id>/notes/pinned', methods=['POST'])
def add_pinned_note(class_id, ta_id):