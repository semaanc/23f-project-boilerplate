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

# Create a new class
@classes.route('/classes', methods=['POST'])
def create_class():

    data = request.get_json()
    current_app.logger.info(data)

    # extracting data
    course_id = data['course_id']
    professor_id = data['professor_id']
    class_id = data['class_id']
    course_name = data['course_name']
    department_name = data['department_name']

    cursor = db.get_db().cursor()
    cursor.execute('INSERT INTO Classes (course_id, class_id, course_name, professor_id, department_name) '
                    'VALUES (%s, %s, %s, %s, %s)', (course_id, class_id, course_name, professor_id, department_name))
    db.get_db().commit()

    the_response = make_response(jsonify(data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response


# View all classes a specific student is enrolled in
@classes.route('/classes/<student_id>', methods=['GET'])
def get_students_classes(student_id):

    cursor = db.get_db().cursor()
    cursor.execute(f'SELECT * FROM Student_Classes WHERE student_id={student_id}')
    row_headers = [x[0] for x in cursor.description]
    classes_data = cursor.fetchall()

    json_data = []
    for cls in classes_data:
        json_data.append(dict(zip(row_headers, cls)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Delete a new class
@classes.route('/classes/<course_id>/<class_id>', methods=['DELETE'])
def delete_class(course_id, class_id, professor_id):
    data = request.get_json()
    professor_id = data['professor_id']
    department_name = data['department_name']
    course_name = data['course_name']

    cursor = db.get_db().cursor()
    cursor.execute('DELETE FROM Classes WHERE course_id = %s AND class_id = %s AND professor_id = %s AND department_name = %s AND course_name = %s', (course_id, class_id, professor_id, department_name, course_name))
    db.get_db().commit()

    removed_class = {'course_id': course_id, 'class_id': class_id, 'professor_id': professor_id, 'department_name': department_name, 'course_name': course_name}
    response_data = {'Class deleted!': [removed_class]}
    response = make_response(jsonify(response_data))
    response.status_code = 200
    response.mimetype = 'application/json'
    return response

# View a specific class
@classes.route('/classes/<course_id>/<class_id>', methods=['GET'])
def view_specific_class(course_id, class_id):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Classes WHERE course_id = %s AND class_id = %s', (course_id, class_id))
    row_headers = [x[0] for x in cursor.description]
    class_data = cursor.fetchall()

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
    cursor.execute('INSERT INTO ClassFolders (folder_name, course_id, class_id) VALUES (%s, %s, %s)', (folder_name, course_id, class_id))
    db.get_db().commit()

    response = jsonify('Class folder created successfully!')
    return response

# View a specific class folder
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

# View notes in a specific class folder
@classes.route('/classes/<course_id>/<class_id>/classfolders/<classf_id>/notes', methods=['GET'])
def get_class_folder_notes(course_id, class_id, classf_id):
    cursor = db.get_db().cursor()

    data = request.get_json()
    classf_id = data['classf_id']

    cursor.execute('SELECT * FROM ClassFolders C JOIN Notes N on C.folder_name = N.class_folder and C.course_id = N.course_id and C.class_id = N.class_id WHERE N.course_id = %s AND N.class_id = %s AND N.class_folder = %s', (course_id, class_id, classf_id))
    row_headers = [x[0] for x in cursor.description]
    class_folders_data = cursor.fetchall()

    json_data = []
    for class_folder in class_folders_data:
        json_data.append(dict(zip(row_headers, class_folder)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Delete a specific class folder
@classes.route('/classes/<course_id>/<class_id>/classfolders/<classf_id>', methods=['DELETE'])
def delete_class_folder(course_id, class_id, classf_id):
    cursor = db.get_db().cursor()
    cursor.execute('DELETE FROM ClassFolders WHERE course_id = %s AND class_id = %s AND folder_name = %s', (course_id, class_id, classf_id))
    db.get_db().commit()

    removed_folder = {'classf_id': classf_id, 'course_id': course_id, 'class_id': class_id}
    response_data = {'Class folder deleted!': [removed_folder]}
    response = make_response(jsonify(response_data))
    response.status_code = 200
    response.mimetype = 'application/json'
    return response

# View all students in a specific class
@classes.route('/classes/<course_id>/<class_id>/students', methods=['GET'])
def view_students_in_class(course_id, class_id):
    cursor = db.get_db().cursor()
    cursor.execute(
        'SELECT s.* FROM Students s '
        'JOIN Student_Classes sc ON s.student_id = sc.student_id '
        'WHERE sc.class_id = %s AND sc.course_id = %s',
        (class_id, course_id)
    )
    row_headers = [x[0] for x in cursor.description]
    classes_data = cursor.fetchall()

    json_data = []
    for cls in classes_data:
        json_data.append(dict(zip(row_headers, cls)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Add a student to a specific class
@classes.route('/classes/<course_id>/<class_id>/students', methods=['POST'])
def add_student_to_class(course_id, class_id):
    data = request.json
    student_id = data['student_id']

    cursor = db.get_db().cursor()
    cursor.execute(
        'INSERT INTO Student_Classes (student_id, course_id, class_id) VALUES (%s, %s, %s)',
        (student_id, course_id, class_id)
    )
    db.get_db().commit()
    return "Success!"

# Remove a student from a specific class
@classes.route('/classes/<course_id>/<class_id>/students/<student_id>', methods=['DELETE'])
def remove_student_from_class(course_id, class_id, student_id):
    cursor = db.get_db().cursor()
    cursor.execute(
        'DELETE FROM Student_Classes WHERE course_id = %s AND class_id = %s AND student_id = %s',
        (course_id, class_id, student_id)
    )
    db.get_db().commit()

    removed_students = {'student_id': student_id, 'course_id': course_id, 'class_id': class_id}
    response_data = {'Student removed from class successfully': [removed_students]}
    response = make_response(jsonify(response_data))
    response.status_code = 200
    response.mimetype = 'application/json'
    return response

# View all TAs in a specific class
@classes.route('/classes/<course_id>/<class_id>/tas', methods=['GET'])
def view_tas_in_class(course_id, class_id):
    cursor = db.get_db().cursor()
    cursor.execute(
        'SELECT ta.* FROM TAs ta '
        'JOIN Classes_TAs cta ON ta.ta_id = cta.ta_id '
        'WHERE cta.class_id = %s AND cta.course_id = %s',
        (class_id, course_id)
    )
    row_headers = [x[0] for x in cursor.description]
    classes_data = cursor.fetchall()

    json_data = []
    for cls in classes_data:
        json_data.append(dict(zip(row_headers, cls)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Add a TA to a specific class
@classes.route('/classes/<course_id>/<class_id>/tas', methods=['POST'])
def add_ta_to_class(course_id, class_id):
    data = request.json
    ta_id = data['ta_id']

    cursor = db.get_db().cursor()
    cursor.execute(
        'INSERT INTO Classes_TAs (ta_id, course_id, class_id) VALUES (%s, %s, %s)',
        (ta_id, course_id, class_id)
    )
    db.get_db().commit()
    return "Success!"


# Remove a TA from a specific class
@classes.route('/classes/<course_id>/<class_id>/tas/<ta_id>', methods=['DELETE'])
def remove_ta_from_class(course_id, class_id, ta_id):
    cursor = db.get_db().cursor()
    cursor.execute(
        'DELETE FROM Classes_TAs WHERE course_id = %s AND class_id = %s AND ta_id = %s',
        (course_id, class_id, ta_id)
    )
    db.get_db().commit()

    removed_tas = {'ta_id': ta_id, 'course_id': course_id, 'class_id': class_id}
    response_data = {'TA removed from class successfully': [removed_tas]}
    response = make_response(jsonify(response_data))
    response.status_code = 200
    response.mimetype = 'application/json'
    return response

# View all office hours hosted for a specific class
@classes.route('/classes/<course_id>/<class_id>/oh', methods=['GET'])
def get_oh(course_id, class_id):

    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM OfficeHours WHERE course_id = %s AND class_id = %s', (course_id, class_id))
    row_headers = [x[0] for x in cursor.description]

    oh_data = cursor.fetchall()

    oh = [{row_headers[i]: str(o) for i, o in enumerate(elem)} for elem in oh_data]

    json_data = dict(zip(row_headers, oh))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    # return jsonify(oh)
    return the_response

# View all office hours hosted by a TA for a specific class
@classes.route('/classes/<course_id>/<class_id>/oh/<ta_id>', methods=['GET'])
def get_ta_oh(course_id, class_id, ta_id):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM OfficeHours WHERE course_id = %s AND class_id = %s AND ta_id = %s', (course_id, class_id, ta_id))
    oh_data = cursor.fetchone()

    row_headers = [x[0] for x in cursor.description]
    json_data = dict(zip(row_headers, oh_data))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# View all the classes a TA helps in
@classes.route('/classes/ta/<ta_id>', methods=['GET'])
def get_ta_classes(ta_id):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Classes_TAs WHERE ta_id = %s', (ta_id,))
    data = cursor.fetchall()

    row_headers = [x[0] for x in cursor.description]
    json_data = []

    for row in data:
        json_data.append(dict(zip(row_headers, row)))

    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response


# Add a new office hour for a TA for a specific class
@classes.route('/classes/<course_id>/<class_id>/oh/<ta_id>', methods=['POST'])
def add_ta_oh(course_id, class_id, ta_id):
    request_data = request.get_json()

    # Assuming request_data contains 'time', 'date', and 'location'
    time = request_data.get('time')
    date = request_data.get('date')
    location = request_data.get('location')

    cursor = db.get_db().cursor()
    cursor.execute('INSERT INTO OfficeHours (ta_id, course_id, class_id, time, date, location) VALUES (%s, %s, %s, %s, %s, %s)',
                   (ta_id, course_id, class_id, class_id, time, date, location))
    db.get_db().commit()

    return "Success!"

# Remove a TA’s office hour for a specific class
@classes.route('/classes/<course_id>/<class_id>/oh/<ta_id>', methods=['DELETE'])
def remove_ta_oh(course_id, class_id, ta_id):
    cursor = db.get_db().cursor()
    cursor.execute('DELETE FROM OfficeHours WHERE course_id = %s AND class_id = %s AND ta_id = %s', (course_id, class_id, ta_id))
    db.get_db().commit()

# View pinned notes in a specific class folder
@classes.route('classes/<course_id>/<class_id>/classfolders/<classf_id>/notes/pinned', methods=['GET'])
def view_pinned_note(course_id, class_id, classf_id):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Notes WHERE course_id = %s AND class_id = %s AND class_folder = %s AND pinned = TRUE', (course_id, class_id, classf_id))
    row_headers = [x[0] for x in cursor.description]
    notes_data = cursor.fetchall()

    json_data = []
    for note in notes_data:
        json_data.append(dict(zip(row_headers, note)))

    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Pin a note in a specific class folder
@classes.route('/classes/<course_id>/<class_id>/classfolders/<classf_id>/notes', methods=['PUT'])
def pin_note_in_class_folder(course_id, class_id, classf_id):
    data = request.get_json()
    note_id = data['note_id']

    cursor = db.get_db().cursor()
    cursor.execute('UPDATE Notes SET pinned = TRUE WHERE note_id = %s', (note_id,))
    db.get_db().commit()

    return "Note pinned successfully!"

# Unpin a note in a specific class folder
@classes.route('/classes/<course_id>/<class_id>/classfolders/<classf_id>/notes/unpin', methods=['PUT'])
def unpin_note_in_class_folder(course_id, class_id, classf_id):
    data = request.get_json()
    note_id = data['note_id']

    cursor = db.get_db().cursor()
    cursor.execute('UPDATE Notes SET pinned = FALSE WHERE note_id = %s', (note_id,))
    db.get_db().commit()

    return "Note unpinned successfully!"