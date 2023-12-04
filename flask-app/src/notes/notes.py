from flask import Blueprint, request, jsonify, make_response
import json
from src import db


notes = Blueprint('notes', __name__)

# View a specific note
@notes.route('/notes/<note_id>', methods=['GET'])
def view_specific_note(note_id):
    try:
        cursor = db.get_db().cursor()
        cursor.execute('SELECT * FROM Notes WHERE (note_id = %s)', (note_id))
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

# Edit a specific note
@notes.route('/notes/<note_id>', methods=['PUT'])
def edit_specific_note():
    try:
        cursor = db.get_db().cursor()
        content = request.json
        cursor.execute('UPDATE Notes SET note_content = %s WHERE (note_id = %s)', (content['note_content'], content['note_id']))
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
def delete_specific_note():
    try:
        cursor = db.get_db().cursor()
        content = request.json
        cursor.execute('DELETE FROM Notes WHERE (note_id = %s)', (content['note_id']))
        db.get_db().commit()
        the_response = make_response(jsonify({"message": "Deleted"}))
        the_response.status_code = 200
        the_response.mimetype = 'application/json'
        return the_response
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
        cursor.execute('INSERT INTO Comments (note_id, comment_content, reply_to) VALUES (%s, %s, %s)', (note_id, content['comment_content'], comment_id))
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
        the_response = make_response(jsonify({"message": "Deleted"}))
        the_response.status_code = 200
        the_response.mimetype = 'application/json'
        return the_response
    except Exception as e:
        error_message = {"error": str(e)}
        the_response = make_response(jsonify(error_message))
        the_response.status_code = 500
        the_response.mimetype = 'application/json'
        return the_response
