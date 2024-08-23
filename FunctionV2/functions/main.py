import json
from firebase_functions import https_fn
from firebase_admin import initialize_app
from firebase_admin import auth
from firebase_admin import firestore


initialize_app()


@https_fn.on_request()
def auth_create_user_admin(req: https_fn.Request) -> https_fn.Response:
    # Parse the JSON body
    req_json = req.get_json(silent=True)

    requestEmail = req_json.get("data", {}).get("email")
    requestPassword = req_json.get("data", {}).get("password")
    role = req_json.get("data", {}).get("role")
    requestNombre = req_json.get("data", {}).get("nombre")

    response_data = {
        "data": {
            "userDataSent": {
                "requestEmail": requestEmail,
                "password": requestPassword,
                "role": role,
                "requestNombre": requestNombre,
            },
        }
    }

    if not requestEmail or not requestPassword or not role or not requestNombre:
        return https_fn.Response(
            json.dumps({"data": "Missing required parameter"}),
            status=400,
            mimetype="application/json",
        )
    try:
        user = auth.create_user(
            email=requestEmail,
            email_verified=True,
            password=requestPassword,
            display_name=requestNombre,
            disabled=False,
        )
        if user:
            firestore_client = firestore.client()

            try:
                user_doc_ref = firestore_client.collection("users").document(user.uid)
                user_data = {
                    "email": requestEmail,
                    "role": role,
                    "nombre": requestNombre,
                    "password": requestPassword,
                    "uid": user.uid,
                }
                result = user_doc_ref.set(user_data)
            except Exception as e:
                print(e)
                return https_fn.Response(
                    json.dumps({"data": {"error": "Error creating user"}}),
                    status=400,
                    mimetype="application/json",
                )

            print("Document written with result: ", result)
            print("Successfully created new user:", user.uid)
            return https_fn.Response(
                json.dumps(
                    {"data": {"message": "User created successfully", "uid": user.uid}}
                ),
            )
        else:
            print("Failed to create new user")
    except Exception as e:
        print(e)
        return https_fn.Response(
            json.dumps({"data": {"error": "Error creating user"}}),
            status=400,
            mimetype="application/json",
        )

    print(response_data)
    return https_fn.Response(json.dumps(response_data), mimetype="application/json")


@https_fn.on_request()
def get_users(req: https_fn.Request) -> https_fn.Response:
    try:
        users = auth.list_users().iterate_all()
        users_list = []
        for user in users:
            users_list.append(
                {
                    "uid": user.uid,
                    "email": user.email,
                    "displayName": user.display_name,
                }
            )

        response = {"data": users_list}
        return https_fn.Response(json.dumps(response), mimetype="application/json")
    except Exception as e:
        print(e)
        return https_fn.Response(
            json.dumps({"data": {"error": "Error getting users"}}),
            status=400,
            mimetype="application/json",
        )


@https_fn.on_request()
def delete_user(req: https_fn.Request) -> https_fn.Response:
    try:
        user_id = req.get_json()["data"]["uid"]
        auth.delete_user(user_id)
        db = firestore.client()
        user_ref = db.collection('users').document(user_id)
        user_ref.delete()
        response = {"data": {"message": "User deleted successfully"}}
        return https_fn.Response(json.dumps(response), mimetype="application/json")
    except Exception as e:
        print(e)
        return https_fn.Response(
            json.dumps({"data": {"error": "Error deleting user"}}),
            status=400,
            mimetype="application/json",
        )