from flask import Blueprint, request, jsonify, make_response
import json
from src import db


departments = Blueprint('departments', __name__)

# Retrieve all classes in a department
@departments.route('/departments/<department_name>/classes', methods=['GET'])
def get_all_classes(department_name):
    
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Classes WHERE department_name = %s', (department_name,))
    row_headers = [x[0] for x in cursor.description]
    classes_data = cursor.fetchall()

    json_data = []
    for cls in classes_data:
        json_data.append(dict(zip(row_headers, cls)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Retrieve all notes in a department
@departments.route('/departments/<department_name>/notes', methods=['GET'])
def get_all_notes(department_name):
    
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Notes WHERE department_name = %s', (department_name,))
    row_headers = [x[0] for x in cursor.description]
    notes_data = cursor.fetchall()

    json_data = []
    for note in notes_data:
        json_data.append(dict(zip(row_headers, note)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Retrieve all announcements in a department
@departments.route('/departments/<department_name>/announcements', methods=['GET'])
def get_all_announcements(department_name):
    
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Announcements WHERE department_name = %s', (department_name,))
    row_headers = [x[0] for x in cursor.description]
    announcements_data = cursor.fetchall()

    json_data = []
    for announcement in announcements_data:
        json_data.append(dict(zip(row_headers, announcement)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Create a new department- wide announcement
@departments.route('/departments/<department_name>/announcements', methods=['POST'])
def create_announcement(department_name):
    cursor = db.get_db().cursor()
    content = request.json
    cursor.execute('INSERT INTO Announcements (announcement_content, department_name) VALUES (%s, %s)', (content['announcement_content'], department_name))
    db.get_db().commit()
    the_response = make_response(jsonify({"message": "Created"}))
    the_response.status_code = 201
    the_response.mimetype = 'application/json'
    return the_response

# View a specific announcement in a department
@departments.route('/departments/<department_name>/announcements/<announcement_id>', methods=['GET'])
def view_specific_announcement(department_name, announcement_id):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Announcements WHERE (department_name = %s) AND (announcement_id = %s)', (department_name, announcement_id))
    row_headers = [x[0] for x in cursor.description]
    announcement_data = cursor.fetchall()
    json_data = []
    for announcement in announcement_data:
        json_data.append(dict(zip(row_headers, announcement)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Edit a specific announcement in a department
@departments.route('/departments/<department_name>/announcements/<announcement_id>', methods=['PUT'])
def edit_specific_announcement(department_name, announcement_id):
    cursor = db.get_db().cursor()
    content = request.json
    cursor.execute('UPDATE Announcements SET announcement_content = %s WHERE (department_name = %s) AND (announcement_id = %s)', (content['announcement_content'], department_name, announcement_id))
    db.get_db().commit()
    the_response = make_response(jsonify({"message": "Updated"}))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Delete a specific announcement in a department
@departments.route('/departments/<department_name>/announcements/<announcement_id>', methods=['DELETE'])
def delete_specific_announcement(department_name, announcement_id):
    cursor = db.get_db().cursor()
    cursor.execute('DELETE FROM Announcements WHERE (department_name = %s) AND (announcement_id = %s)', (department_name, announcement_id))
    db.get_db().commit()
    the_response = make_response(jsonify({"message": "Deleted"}))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# # View all of the department's statistics
# @departments.route('/departments/<department_name>/statistics', methods=['GET'])
# def view_department_statistics(department_name):
    
