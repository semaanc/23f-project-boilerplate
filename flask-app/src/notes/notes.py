from flask import Blueprint, request, jsonify, make_response
import json
from src import db


notes = Blueprint('notes', __name__)

# View all notes
@notes.route('/notes', methods=['GET'])
def get_all_notes():
    try:
        cursor = db.get_db().cursor()
        cursor.execute(f'SELECT * FROM Notes')
        row_headers = [x[0] for x in cursor.description]
        note_data = cursor.fetchall()
        json_data = []
        for note in note_data:
            json_data.append(dict(zip(row_headers, note)))
        the_response = make_response(jsonify(json_data))
        the_response.status_code = 200
        the_response.mimetype = 'application/json'
        return the_response
    except Exception as e:
        error_message = {"error": str(e)}
        the_response = make_response(jsonify(error_message))
        the_response.status_code = 500
        the_response.mimetype = 'application/json'
        return the_response
    

# View all nonreported notes for a class
@notes.route('/notes/<course_id>/<class_id>', methods=['GET'])
def get_all_notes_for_class(course_id, class_id):
    try:
        cursor = db.get_db().cursor()
        cursor.execute(f'SELECT * FROM Notes WHERE (reported = FALSE) AND course_id = {course_id} AND class_id = {class_id}')
        row_headers = [x[0] for x in cursor.description]
        note_data = cursor.fetchall()
        json_data = []
        for note in note_data:
            json_data.append(dict(zip(row_headers, note)))
        the_response = make_response(jsonify(json_data))
        the_response.status_code = 200
        the_response.mimetype = 'application/json'
        return the_response
    except Exception as e:
        error_message = {"error": str(e)}
        the_response = make_response(jsonify(error_message))
        the_response.status_code = 500
        the_response.mimetype = 'application/json'
        return the_response
    
# View a specific note
@notes.route('/notes/<note_id>', methods=['GET'])
def view_specific_note(note_id):
    try:
        cursor = db.get_db().cursor()
        cursor.execute('SELECT * FROM Notes WHERE (note_id = %s) AND (reported = FALSE)', (note_id))
        row_headers = [x[0] for x in cursor.description]
        note_data = cursor.fetchall()
        json_data = []
        for note in note_data:
            json_data.append(dict(zip(row_headers, note)))
        the_response = make_response(jsonify(json_data))
        the_response.status_code = 200
        the_response.mimetype = 'application/json'
        return the_response
    except Exception as e:
        error_message = {"error": str(e)}
        the_response = make_response(jsonify(error_message))
        the_response.status_code = 500
        the_response.mimetype = 'application/json'
        return the_response

# Add a note
@notes.route('/notes', methods=['POST'])
def add_new_note():
    try:
        cursor = db.get_db().cursor()
        content = request.json
        cursor.execute('INSERT INTO Notes (student_id, note_content, student_folder, class_folder, class_id, course_id) VALUES (%s, %s, %s, %s, %s, %s)', (content["student_id"], content["note_content"], content["student_folder"], content["class_folder"], content["class_id"], content["course_id"]))
        db.get_db().commit()
        the_response = make_response(jsonify({"message": "Note added"}))
        the_response.status_code = 200
        the_response.mimetype = 'application/json'
        return the_response
    except Exception as e:
        error_message = {"error": str(e)}
        the_response = make_response(jsonify(error_message))
        the_response.status_code = 500
        the_response.mimetype = 'application/json'
        return the_response
    
# Edit a specific note
@notes.route('/notes/<note_id>', methods=['PUT'])
def edit_specific_note(note_id):
    try:
        cursor = db.get_db().cursor()
        content = request.json
        cursor.execute('UPDATE Notes SET note_content = %s WHERE (note_id = %s)', (content['note_content'], note_id))
        db.get_db().commit()
        the_response = make_response(jsonify({"message": "Edited"}))
        the_response.status_code = 200
        the_response.mimetype = 'application/json'
        return the_response
    except Exception as e:
        error_message = {"error": str(e)}
        the_response = make_response(jsonify(error_message))
        the_response.status_code = 500
        the_response.mimetype = 'application/json'
        return the_response

# Delete a specific note
@notes.route('/notes/<note_id>', methods=['DELETE'])
def delete_specific_note(note_id):
    try:
        cursor = db.get_db().cursor()
        cursor.execute('DELETE FROM Notes WHERE (note_id = %s)', (note_id,))
        db.get_db().commit()
        return "Deleted"
    except Exception as e:
        error_message = {"error": str(e)}
        the_response = make_response(jsonify(error_message))
        the_response.status_code = 500
        the_response.mimetype = 'application/json'
        return the_response

# View all comments on a specific note
@notes.route('/notes/<note_id>/comments', methods=['GET'])
def view_all_comments(note_id):
    try:
        cursor = db.get_db().cursor()
        cursor.execute('SELECT * FROM Comments WHERE (note_id = %s)', (note_id))
        row_headers = [x[0] for x in cursor.description]
        comments_data = cursor.fetchall()
        json_data = []
        for comment in comments_data:
            json_data.append(dict(zip(row_headers, comment)))
        the_response = make_response(jsonify(json_data))
        the_response.status_code = 200
        the_response.mimetype = 'application/json'
        return the_response
    except Exception as e:
        error_message = {"error": str(e)}
        the_response = make_response(jsonify(error_message))
        the_response.status_code = 500
        the_response.mimetype = 'application/json'
        return the_response

# Add a new comment to a specific note
@notes.route('/notes/<note_id>/comments', methods=['POST'])
def add_new_comment(note_id):
    try:
        cursor = db.get_db().cursor()
        content = request.json
        cursor.execute('INSERT INTO Comments (note_id, comment_content) VALUES (%s, %s)', (note_id, content['comment_content']))
        db.get_db().commit()
        the_response = make_response(jsonify({"message": "Created"}))
        the_response.status_code = 201
        the_response.mimetype = 'application/json'
        return the_response
    except Exception as e:
        error_message = {"error": str(e)}
        the_response = make_response(jsonify(error_message))
        the_response.status_code = 500
        the_response.mimetype = 'application/json'
        return the_response

# View a specific comment on a specific note
@notes.route('/notes/<note_id>/comments/<comment_id>', methods=['GET'])
def view_specific_comment(note_id, comment_id):
    try:
        cursor = db.get_db().cursor()
        cursor.execute('SELECT * FROM Comments WHERE (note_id = %s) AND (comment_id = %s)', (note_id, comment_id))
        row_headers = [x[0] for x in cursor.description]
        comment_data = cursor.fetchall()
        json_data = []
        for comment in comment_data:
            json_data.append(dict(zip(row_headers, comment)))
        the_response = make_response(jsonify(json_data))
        the_response.status_code = 200
        the_response.mimetype = 'application/json'
        return the_response
    except Exception as e:
        error_message = {"error": str(e)}
        the_response = make_response(jsonify(error_message))
        the_response.status_code = 500
        the_response.mimetype = 'application/json'
        return the_response

# Add a reply to a specific comment on a specific note
@notes.route('/notes/<note_id>/comments/<comment_id>', methods=['POST'])
def add_reply_to_comment(note_id, comment_id):
    try:
        cursor = db.get_db().cursor()
        content = request.json
        cursor.execute('INSERT INTO Comments (note_id, comment_content) VALUES (%s, %s)', (note_id, content['comment_content']))
        db.get_db().commit()
        the_response = make_response(jsonify({"message": "Created"}))
        the_response.status_code = 201
        the_response.mimetype = 'application/json'
        return the_response
    except Exception as e:
        error_message = {"error": str(e)}
        the_response = make_response(jsonify(error_message))
        the_response.status_code = 500
        the_response.mimetype = 'application/json'
        return the_response

# Edit a specific comment on a specific note
@notes.route('/notes/<note_id>/comments/<comment_id>', methods=['PUT'])
def edit_specific_comment(note_id, comment_id):
    try:
        cursor = db.get_db().cursor()
        content = request.json
        cursor.execute('UPDATE Comments SET comment_content = %s WHERE (note_id = %s) AND (comment_id = %s)', (content['comment_content'], note_id, comment_id))
        db.get_db().commit()
        the_response = make_response(jsonify({"message": "Edited"}))
        the_response.status_code = 200
        the_response.mimetype = 'application/json'
        return the_response
    except Exception as e:
        error_message = {"error": str(e)}
        the_response = make_response(jsonify(error_message))
        the_response.status_code = 500
        the_response.mimetype = 'application/json'
        return the_response

# Delete a specific comment on a specific note
@notes.route('/notes/<note_id>/comments/<comment_id>', methods=['DELETE'])
def delete_specific_comment(note_id, comment_id):
    try:
        cursor = db.get_db().cursor()
        cursor.execute('DELETE FROM Comments WHERE (note_id = %s) AND (comment_id = %s)', (note_id, comment_id))
        db.get_db().commit()
        return "Deleted!"
    except Exception as e:
        error_message = {"error": str(e)}
        the_response = make_response(jsonify(error_message))
        the_response.status_code = 500
        the_response.mimetype = 'application/json'
        return the_response
