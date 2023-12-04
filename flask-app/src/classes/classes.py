from flask import Blueprint, request, jsonify, make_response, current_app
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
    
    data = request.get_json()
    current_app.logger.info(data)

    # extracting data
    course_id = data['course_id']
    class_id = data['class_id']
    course_name = data['course_name']
    professor_id = data['professor_id']
    department_name = data['department_name']

    cursor = db.get_db().cursor()
    cursor.execute('INSERT INTO Classes (course_id, class_id, course_name, professor_id, department_name) '
                    'VALUES (%s, %s, %s, %s, %s)', (course_id, class_id, course_name, professor_id, department_name))
    db.get_db().commit()

    return 'Success!'

# View a specific class
@classes.route('/classes/<course_id>/<class_id>', methods=['GET'])
def view_specific_class(course_id, class_id):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Classes WHERE course_id = %s AND class_id = %s', (course_id, class_id))
    row_headers = [x[0] for x in cursor.description]
    class_data = cursor.fetchone()

    if class_data: # not null
        json_data = dict(zip(row_headers, class_data))
        the_response = make_response(jsonify(json_data))
        the_response.status_code = 200
        the_response.mimetype = 'application/json'
        return the_response
    else:
        response = jsonify({'message': 'Class not found'})
        response.status_code = 404
        return response

# View all the class’s folders
@classes.route('/classes/<course_id>/<class_id>/classfolders', methods=['GET'])
def get_class_folders(course_id, class_id):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM ClassFolders WHERE course_id = %s AND class_id = %s', (course_id, class_id))
    row_headers = [x[0] for x in cursor.description]
    class_folders_data = cursor.fetchall()

    json_data = []
    for class_folder in class_folders_data:
        json_data.append(dict(zip(row_headers, class_folder)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Create a new class folder
@classes.route('/classes/<course_id>/<class_id>/classfolders', methods=['POST'])
def create_class_folder(course_id, class_id):
    
    data = request.get_json()
    folder_name = data['folder_name']
    
    cursor = db.get_db().cursor()
    cursor.execute('INSERT INTO ClassFolders (folder_name, course_id, class_id) VALUES (%s, %s)', (folder_name, course_id, class_id))
    db.get_db().commit()

    response = jsonify('Class folder created successfully!')
    return response


@classes.route('/classes/<course_id>/<class_id>/classfolders/<classf_id>', methods=['GET'])
def get_class_folder(course_id, class_id, classf_id):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM ClassFolders WHERE course_id = %s AND class_id = %s AND folder_name = %s', (course_id, class_id, classf_id,))
    row_headers = [x[0] for x in cursor.description]
    class_folder_data = cursor.fetchone()

    json_data = dict(zip(row_headers, class_folder_data))
    response = make_response(jsonify(json_data))
    response.status_code = 200
    response.mimetype = 'application/json'
    return response


@classes.route('/classes/<class_id>/classfolders/<classf_id>', methods=['POST'])
def create_class_folder(classf_id):
    data = request.get_json()
    folder_name = data['folder_name']
    
    cursor = db.get_db().cursor()
    cursor.execute('INSERT INTO ClassFolders (folder_name, class_id) VALUES (%s, %s)', (folder_name, class_id))
    db.get_db().commit()

    response = jsonify({'message': 'Class folder created successfully!'})
    response.status_code = 201
    return response

@classes.route('/classes/<class_id>/students', methods=['GET'])
def view_students_in_class(class_id):
    cursor = db.get_db().cursor()
    cursor.execute(
        'SELECT s.* FROM Students s '
        'JOIN Student_Classes sc ON s.student_id = sc.student_id '
        'WHERE sc.class_id = ?',
        (class_id,)
    )
    row_headers = [x[0] for x in cursor.description]
    students_data = cursor.fetchall()

    json_data = []
    for student in students_data:
        json_data.append(dict(zip(row_headers, student)))

    response = make_response(jsonify(json_data))
    response.status_code = 200
    response.mimetype = 'application/json'
    return response


@classes.route('/classes/<class_id>/students', methods=['POST'])
def add_student_to_class(class_id):
    data = request.json
    student_id = data['student_id']

    cursor = db.get_db().cursor()
    cursor.execute(
        'INSERT INTO Student_Classes (student_id, class_id) VALUES (?, ?)',
        (student_id, class_id)
    )
    db.get_db().commit()
    return "Success!"

@classes.route('/classes/<class_id>/students/<student_id>', methods=['DELETE'])
def remove_student_from_class(class_id, student_id):
    cursor = db.get_db().cursor()
    cursor.execute(
        'DELETE FROM Student_Classes WHERE class_id = ? AND student_id = ?',
        (class_id, student_id)
    )
    db.get_db().commit()

    response = make_response(jsonify({'Student removed from class successfully'}))
    response.status_code = 200
    response.mimetype = 'application/json'
    return response

@classes.route('/classes/<class_id>/oh/<ta_id>', methods=['GET'])
def get_ta_oh(class_id, ta_id):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM OfficeHours WHERE class_id = %s AND ta_id = %s', (class_id, ta_id))
    oh_data = cursor.fetchone()

    row_headers = [x[0] for x in cursor.description]
    json_data = dict(zip(row_headers, oh_data))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

@classes.route('/classes/<class_id>/oh/<ta_id>', methods=['POST'])
def add_ta_oh(class_id, ta_id):
    request_data = request.get_json()

    # Assuming request_data contains 'time', 'date', and 'location'
    time = request_data.get('time')
    date = request_data.get('date')
    location = request_data.get('location')

    cursor = db.get_db().cursor()
    cursor.execute('INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date, location) VALUES (%s, (SELECT course_id FROM Classes WHERE class_id = %s), %s, %s, %s, %s)',
                   (ta_id, class_id, class_id, time, date, location))
    db.get_db().commit()

    return "Success!"

@classes.route('/classes/<class_id>/oh/<ta_id>', methods=['REMOVE'])
def remove_ta_oh(class_id, ta_id):
    cursor = db.get_db().cursor()
    cursor.execute('DELETE FROM OfficeHours WHERE class_id = %s AND ta_id = %s', (class_id, ta_id))
    db.get_db().commit()

@classes.route('classes/<class_id>/classfolders/<classf_id>/notes/pinned', methods=['GET'])
def view_pinned_note(class_id, classf_id):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Notes WHERE class_id = %s AND class_folder = %s AND pinned = TRUE', (class_id, classf_id))
    row_headers = [x[0] for x in cursor.description]
    notes_data = cursor.fetchall()

    json_data = []
    for note in notes_data:
        json_data.append(dict(zip(row_headers, note)))

    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response


@classes.route('classes/<class_id>/classfolders/<classf_id>/notes/pinned', methods=['POST'])
def add_pinned_note(class_id, classf_id):
    data = request.get_json()

    student_id = data.get('student_id')
    note_content = data.get('note_content')
    reported = data.get('reported', False)
    pinned = data.get('pinned', True)

    cursor = db.get_db().cursor()
    cursor.execute('INSERT INTO Notes (student_id, note_content, reported, pinned, class_folder, class_id) VALUES (%s, %s, %s, %s, %s, %s)',
                   (student_id, note_content, reported, pinned, classf_id, class_id))
    db.get_db().commit()

    response_data = {'Pinned note added successfully'}
    response = make_response(jsonify(response_data))
    response.status_code = 200
    response.mimetype = 'application/json'
    return response