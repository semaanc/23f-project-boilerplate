from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db


students = Blueprint('students', __name__)

# View a student profile
@students.route('/students/<student_id>', methods=['GET'])
def get_student(student_id):
    cursor = db.get_db().cursor()

    cursor.execute(f'SELECT * FROM Students WHERE student_id={student_id}')
    
    column_headers = [x[0] for x in cursor.description]

    json_student_data = []

    student_data = cursor.fetchall()

    for row in student_data:
        json_student_data.append(dict(zip(column_headers, row)))

    response = jsonify(json_student_data)

    return response

# View all of a student's folders
@students.route('/students/<student_id>/studentfolders', methods=['GET'])
def get_specific_student_student_folders(student_id):
    cursor = db.get_db().cursor()

    cursor.execute(f'SELECT * FROM StudentFolders WHERE student_id={student_id}')
    
    column_headers = [x[0] for x in cursor.description]

    json_folder_data = []

    folder_data = cursor.fetchall()

    for row in folder_data:
        json_folder_data.append(dict(zip(column_headers, row)))

    response = jsonify(json_folder_data)

    return response

# Add a student folder
@students.route('/students/<student_id>/studentfolders', methods=['POST'])
def add_new_student_folder(student_id):
    data = request.json
    folder_name = data['folder_name']

    cursor = db.get_db().cursor()
    cursor.execute(
        'INSERT INTO StudentFolders (folder_name, student_id) VALUES (%s, %s)',
        (folder_name, student_id)
    )
    db.get_db().commit()
    return "Success!"

# View contents of a specific student folder
@students.route('/students/<student_id>/studentfolders/<folder_name>/notes', methods=['GET'])
def get_notes_in_student_folder(student_id, folder_name):
    cursor = db.get_db().cursor()

    cursor.execute('SELECT * FROM StudentFolders s JOIN Notes N on s.folder_name = N.student_folder WHERE s.student_id = %s AND s.folder_name = %s', (student_id, folder_name))
    row_headers = [x[0] for x in cursor.description]
    student_folder_data = cursor.fetchall()

    json_data = []
    for student_folder in student_folder_data:
        json_data.append(dict(zip(row_headers, student_folder)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Delete a specific student folder
@students.route('/students/<student_id>/studentfolders', methods=['DELETE'])
def delete_student_folder(student_id):
    # collecting data from the request object 
    data = request.json
    folder_name = data["folder_name"]
    
    cursor = db.get_db().cursor()
    cursor.execute('DELETE FROM StudentFolders WHERE student_id = %s AND folder_name = %s', (student_id, folder_name))
    
    db.get_db().commit()

    removed_folder = {'student_id': student_id, 'folder_name': folder_name}
    response_data = {'Student folder deleted!': [removed_folder]}
    response = make_response(jsonify(response_data))
    response.status_code = 200
    response.mimetype = 'application/json'
    return response
