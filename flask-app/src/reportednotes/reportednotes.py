from flask import Blueprint, request, jsonify, make_response
import json
from src import db


reportednotes = Blueprint('reportednotes', __name__)

# View all reported notes
@reportednotes.route('/reportednotes', methods=['GET'])
def get_all_reportednotes():
    
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Notes WHERE (reported)')
    row_headers = [x[0] for x in cursor.description]
    reportednotes_data = cursor.fetchall()

    json_data = []
    for rnote in reportednotes_data:
        json_data.append(dict(zip(row_headers, rnote)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Add a new reported note
@reportednotes.route('/reportednotes', methods=['POST'])
def create_reportednote():
    cursor = db.get_db().cursor()
    content = request.json
    cursor.execute('INSERT INTO Notes (student_id, note_content, reported, pinned, class_folder) VALUES (%s, %s, TRUE, %s, %s)', (content['student_id'], content['note_content'], content['pinned'], content['class_folder']))
    db.get_db().commit()
    the_response = make_response(jsonify({"message": "Created"}))
    the_response.status_code = 201
    the_response.mimetype = 'application/json'
    return the_response

# View a specific reported note
@reportednotes.route('/reportednotes/<note_id>', methods=['GET'])
def view_specific_reportednote(note_id):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Notes WHERE (note_id = %s) AND (reported)', (note_id))
    row_headers = [x[0] for x in cursor.description]
    reportednote_data = cursor.fetchall()
    json_data = []
    for rnote in reportednote_data:
        json_data.append(dict(zip(row_headers, rnote)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Delete a reported note
@reportednotes.route('/reportednotes/<note_id>', methods=['DELETE'])
def delete_reportednote(note_id):
    cursor = db.get_db().cursor()
    cursor.execute('DELETE FROM Notes WHERE (note_id = %s) AND (reported)', (note_id))
    db.get_db().commit()
    the_response = make_response(jsonify({"message": "Deleted"}))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response