import 'dart:convert';

ChoosenUser choosenUserFromJson(String str) => ChoosenUser.fromJson(json.decode(str));
Review reviewFromJson(String str) => Review.fromJson(json.decode(str));
User userFromJson(String str) => User.fromJson(json.decode(str));

String choosenUserToJson(ChoosenUser data) => json.encode(data.toJson());
String reviewToJson(Review data) => json.encode(data.toJson());
String userToJson(User data) => json.encode(data.toJson());

class ChoosenUser {
    List<UserClass> user;
    List<ProfileModel> profile;

    ChoosenUser({
        required this.user,
        required this.profile,
    });

    factory ChoosenUser.fromJson(Map<String, dynamic> json) => ChoosenUser(
        user: List<UserClass>.from(json["user"].map((x) => UserClass.fromJson(x))),
        profile: List<ProfileModel>.from(json["profile"].map((x) => ProfileModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "user": List<dynamic>.from(user.map((x) => x.toJson())),
        "profile": List<dynamic>.from(profile.map((x) => x.toJson())),
    };
}

class User {
    String model;
    int pk;
    UserFields fields;
    UserClass user;
    ProfileModel profile;

    User({
        required this.model,
        required this.pk,
        required this.fields,
        required this.user,
        required this.profile,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        model: json["model"],
        pk: json["pk"],
        fields: UserFields.fromJson(json["fields"]),
        user: UserClass.fromJson(json["user"]),
        profile: ProfileModel.fromJson(json["profile"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
        "user": user.toJson(),
        "profile": profile.toJson(),
    };
}

class UserFields {
    int account;
    List<dynamic> interestSubjects;
    List<dynamic> matchSent;
    List<int> matchReceived;

    UserFields({
        required this.account,
        required this.interestSubjects,
        required this.matchSent,
        required this.matchReceived,
    });

    factory UserFields.fromJson(Map<String, dynamic> json) => UserFields(
        account: json["account"],
        interestSubjects: List<dynamic>.from(json["interest_subjects"].map((x) => x)),
        matchSent: List<dynamic>.from(json["match_sent"].map((x) => x)),
        matchReceived: List<int>.from(json["match_received"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "account": account,
        "interest_subjects": List<dynamic>.from(interestSubjects.map((x) => x)),
        "match_sent": List<dynamic>.from(matchSent.map((x) => x)),
        "match_received": List<dynamic>.from(matchReceived.map((x) => x)),
    };
}

class ProfileModel {
    String model;
    int pk;
    ProfileModelFields fields;

    ProfileModel({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        model: json["model"],
        pk: json["pk"],
        fields: ProfileModelFields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class ProfileModelFields {
    int member;
    int age;
    String bio;

    ProfileModelFields({
        required this.member,
        required this.age,
        required this.bio,
    });

    factory ProfileModelFields.fromJson(Map<String, dynamic> json) => ProfileModelFields(
        member: json["member"],
        age: json["age"],
        bio: json["bio"],
    );

    Map<String, dynamic> toJson() => {
        "member": member,
        "age": age,
        "bio": bio,
    };
}

class UserClass {
    String model;
    int pk;
    UserFieldsClass fields;

    UserClass({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory UserClass.fromJson(Map<String, dynamic> json) => UserClass(
        model: json["model"],
        pk: json["pk"],
        fields: UserFieldsClass.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class UserFieldsClass {
    String password;
    DateTime lastLogin;
    bool isSuperuser;
    String username;
    String firstName;
    String lastName;
    String email;
    bool isStaff;
    bool isActive;
    DateTime dateJoined;
    List<dynamic> groups;
    List<dynamic> userPermissions;

    UserFieldsClass({
        required this.password,
        required this.lastLogin,
        required this.isSuperuser,
        required this.username,
        required this.firstName,
        required this.lastName,
        required this.email,
        required this.isStaff,
        required this.isActive,
        required this.dateJoined,
        required this.groups,
        required this.userPermissions,
    });

    factory UserFieldsClass.fromJson(Map<String, dynamic> json) => UserFieldsClass(
        password: json["password"],
        lastLogin: DateTime.parse(json["last_login"]),
        isSuperuser: json["is_superuser"],
        username: json["username"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        isStaff: json["is_staff"],
        isActive: json["is_active"],
        dateJoined: DateTime.parse(json["date_joined"]),
        groups: List<dynamic>.from(json["groups"].map((x) => x)),
        userPermissions: List<dynamic>.from(json["user_permissions"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "password": password,
        "last_login": lastLogin.toIso8601String(),
        "is_superuser": isSuperuser,
        "username": username,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "is_staff": isStaff,
        "is_active": isActive,
        "date_joined": dateJoined.toIso8601String(),
        "groups": List<dynamic>.from(groups.map((x) => x)),
        "user_permissions": List<dynamic>.from(userPermissions.map((x) => x)),
    };
}

class LoginUser {
  int id;
  String username;

  LoginUser({required this.id, required this.username});
}

class Review {
    String model;
    int pk;
    ReviewFields fields;
    Book book;

    Review({
        required this.model,
        required this.pk,
        required this.fields,
        required this.book,
    });

    factory Review.fromJson(Map<String, dynamic> json) => Review(
        model: json["model"],
        pk: json["pk"],
        fields: ReviewFields.fromJson(json["fields"]),
        book: Book.fromJson(json["book"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
        "book": book.toJson(),
    };
}

class Book {
    String model;
    int pk;
    BookFields fields;

    Book({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Book.fromJson(Map<String, dynamic> json) => Book(
        model: json["model"],
        pk: json["pk"],
        fields: BookFields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class BookFields {
    String title;
    String author;
    int year;
    List<int> subjects;

    BookFields({
        required this.title,
        required this.author,
        required this.year,
        required this.subjects,
    });

    factory BookFields.fromJson(Map<String, dynamic> json) => BookFields(
        title: json["title"],
        author: json["author"],
        year: json["year"],
        subjects: List<int>.from(json["subjects"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "author": author,
        "year": year,
        "subjects": List<dynamic>.from(subjects.map((x) => x)),
    };
}

class ReviewFields {
    int reviewer;
    int book;
    String review;

    ReviewFields({
        required this.reviewer,
        required this.book,
        required this.review,
    });

    factory ReviewFields.fromJson(Map<String, dynamic> json) => ReviewFields(
        reviewer: json["reviewer"],
        book: json["book"],
        review: json["review"],
    );

    Map<String, dynamic> toJson() => {
        "reviewer": reviewer,
        "book": book,
        "review": review,
    };
}
