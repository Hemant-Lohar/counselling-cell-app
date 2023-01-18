import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'userPage.dart';

class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  String name = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Card(
          child: TextField(
            textAlignVertical: TextAlignVertical.center,
            decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search), hintText: 'Search'),
            onChanged: (val) {
              setState(() {
                name = val;
              });
            },
          ),
        )),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshots) {
            return (snapshots.connectionState == ConnectionState.waiting)
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: snapshots.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshots.data!.docs[index].data()
                          as Map<String, dynamic>;

                      if (name.isEmpty) {
                        return Container(
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.only(left: 10),
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UserPage(
                                          id: data['id'].toString(),
                                        )),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              // backgroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 8),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                            ),
                            child: Text(
                              data['name'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.white,
                                  backgroundColor: Colors.blue,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        );

                        // return ListTile(
                        //   title: Text(
                        //     data['name'],
                        //     maxLines: 1,
                        //     overflow: TextOverflow.ellipsis,
                        //     style: const TextStyle(
                        //         color: Colors.white,
                        //         backgroundColor: Colors.blue,
                        //         fontSize: 16,
                        //         fontWeight: FontWeight.bold),
                        //   ),
                        //   // subtitle: Text(
                        //   //   data['id'],
                        //   //   maxLines: 1,
                        //   //   overflow: TextOverflow.ellipsis,
                        //   //   style: const TextStyle(
                        //   //       color: Colors.black54,
                        //   //       fontSize: 16,
                        //   //       fontWeight: FontWeight.bold),
                        //   // ),
                        //   onTap:(){
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) =>
                        //           UserPage( id: data['id'].toString(),)),
                        // );

                        //   } ,
                        //   // leading: CircleAvatar(
                        //   //   backgroundImage: NetworkImage(data['image']),
                        //   // ),
                        // );
                      } else if (data['name']
                          .toString()
                          .toLowerCase()
                          .startsWith(name.toLowerCase())) {
                        return Container(
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.only(left: 10),
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UserPage(
                                          id: data['id'].toString(),
                                        )),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              // backgroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 8),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                            ),
                            child: Text(
                              data['name'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.white,
                                  backgroundColor: Colors.blue,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      } 
                      return Container();
                    }
                    );
          },
        )
    );
  }
}
