import 'dart:io';

import 'package:cspc_recog/board/model/model_board.dart';
import 'package:cspc_recog/board/screen/screen_post.dart';
import 'package:cspc_recog/common/custom_icons_icons.dart';
import 'package:cspc_recog/providers/userData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cspc_recog/urls.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class EditPostScreen extends StatefulWidget {
  Post post;
  int boardId;
  String boardName;
  EditPostScreen({this.post, this.boardId, this.boardName});
  @override
  _EditPostScreenState createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  final formKey = GlobalKey<FormState>();
  Post editedPost;
  String title = '';
  //TODO
  int profileId; //임시 프로필 아이디
  String content = '';

  final ImagePicker picker = ImagePicker();
  List<XFile> files = [];

  bool isLoading = false;
  List<Comment> comments = [];
  List<ImageUrl> images = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getImageFile();
  }

  void getImageFile() async {
    final List<ImageUrl> urls = await getImages(content, widget.post.id);

    final documentDirectory = await getApplicationDocumentsDirectory();

    urls.forEach((element) async {
      final image = await http
          .get(Uri.parse(UrlPrefix.urls + element.imgUrl.substring(1)));
      File file =
          File(documentDirectory.path + '${element.imgUrl.split('/').last}');
      await file.writeAsBytes(image.bodyBytes);
      setState(() {
        files.add(XFile(file.path));
      });
    });
    print(files.length);
  }

  _editPost() async {
    var request = http.MultipartRequest('PUT',
        Uri.parse(UrlPrefix.urls + 'board/post/' + widget.post.id.toString()));
    request.fields['title'] = title;
    request.fields['author'] = profileId.toString();
    request.fields['contents'] = content;
    request.fields['board_id'] = widget.boardId.toString();
    if (files.isNotEmpty) {
      /*
      widget.post.hasImage = true;
      files.forEach((file) async {
        request.files.add(
          http.MultipartFile('image', (http.ByteStream(file.openRead())).cast(),
              await file.length(),
              filename: file.name + '.jpg'),
        );
      });
      */
      widget.post.hasImage = true;
      await Future.forEach(
          files,
          (file) async => {
                request.files.add(
                  http.MultipartFile(
                      'image',
                      (http.ByteStream(file.openRead())).cast(),
                      await file.length(),
                      filename: widget.boardId.toString() + '.jpg'),
                ),
              });
    } else {
      widget.post.hasImage = false;
    }
    request.fields['has_image'] = widget.post.hasImage.toString();
    final response = await request.send();
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('falied!');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    MyLoginUser myLogin = Provider.of<MyLoginUser>(context, listen: false);
    profileId = myLogin.getProfile().profileId;
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          leadingWidth: width * 0.15,
          leading: IconButton(
            icon: Icon(CustomIcons.close),
            color: Colors.black,
            iconSize: height * 0.025,
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Column(
            children: [
              Text(
                "글 수정",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              Text(
                widget.boardName,
                style: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              )
            ],
          ),
          actions: [
            TextButton(
                onPressed: () async {
                  if (formKey.currentState.validate()) {
                    print('form 완료');
                    this.formKey.currentState.save();
                    await _editPost();
                    print("1");
                    editedPost = await getPost(context, widget.post.id);
                    Navigator.pop(context, editedPost);
                  } else {
                    print('nono 안됨');
                  }
                },
                child: Text(
                  "완료",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ))
          ],
        ),
        body: Column(children: [
          Container(height: height * 0.01),
          Form(
            key: this.formKey,
            child: Column(
              children: [
                Container(
                  width: width * 0.9,
                  decoration: BoxDecoration(
                    //color: Colors.black.withOpacity(0.7),
                    border: Border(
                        bottom: BorderSide(
                      width: 1,
                      color: Colors.black.withOpacity(0.5),
                    )),
                  ),
                  child: Container(
                    //width: width*0.7,
                    padding: EdgeInsets.fromLTRB(width * 0.024, 0, 0, 0),
                    child: TextFormField(
                      initialValue: widget.post.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(30),
                      ],
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: '제목',
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      onSaved: (val) {
                        this.title = val;
                      },
                      validator: (val) {
                        if (val.length < 1) {
                          return '제목은 비어있으면 안됩니다';
                        }
                        return null;
                      },
                      //autovalidateMode: AutovalidateMode.always,
                    ),

                    ///제목
                  ),
                ),
                Container(height: height * 0.012),
                Container(
                  width: width * 0.9,
                  height: height * 0.5,
                  child: Container(
                      padding: EdgeInsets.fromLTRB(width * 0.024, 0, 0, 0),
                      child: TextFormField(
                        initialValue: widget.post.contents,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '내용',
                        ),
                        maxLines: 10,
                        keyboardType: TextInputType.multiline,
                        onSaved: (val) {
                          this.content = val;
                        },
                        validator: (val) {
                          if (val.length < 1) {
                            return '내용을 작성해주세요';
                          }
                          return null;
                        },
                      )

                      ///내용
                      ),
                ),
                imagePreview(context, height, width),

                ///사진
              ],
            ),
          ),
        ]));
  }

  Widget imagePreview(context, double height, double width) {
    return Container(
      alignment: Alignment.bottomLeft,
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.1,
        vertical: height * 0.01,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // added line
            mainAxisSize: MainAxisSize.min, // added line
            children: <Widget>[
              GestureDetector(
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      border: Border.all(width: 1, color: Color(0xFFD4D4D4)),
                      color: Color(0xffE4E4E4),
                    ),
                    width: height * 0.15,
                    height: height * 0.15,
                    child: Icon(CustomIcons.camera)),
                onTap: () => takeImage(context),
              ),
              ...files
                  .map((file) => Padding(
                        padding: EdgeInsets.only(left: width * 0.05),
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                border: Border.all(
                                    width: 1, color: Color(0xFFD4D4D4)),
                              ),
                              width: height * 0.15,
                              height: height * 0.15,
                              child: Image.file(
                                File(file.path),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: CircleAvatar(
                                radius: height * 0.02,
                                backgroundColor: Color(0xFFD4D4D4),
                                foregroundColor: Colors.black54,
                                child: IconButton(
                                    iconSize: height * 0.015,
                                    onPressed: () {
                                      setState(() {
                                        files.remove(file);
                                      });
                                    },
                                    icon: Icon(CustomIcons.close)),
                              ),
                            )
                          ],
                        ),
                      ))
                  .toList()
            ]),
      ),
    );
  }

  takeImage(mContext) {
    return showDialog(
        context: mContext,
        builder: (context) {
          return SimpleDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              title: Text('이미지 선택',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  )),
              children: <Widget>[
                SimpleDialogOption(
                  child:
                      Text('카메라로 찍기', style: TextStyle(color: Colors.black54)),
                  onPressed: captureImageWithCamera,
                ),
                SimpleDialogOption(
                  child:
                      Text('갤러리에서 선택', style: TextStyle(color: Colors.black54)),
                  onPressed: pickImageFromGallery,
                ),
                SimpleDialogOption(
                  child: Text('취소', style: TextStyle(color: Colors.black54)),
                  onPressed: () => Navigator.pop(context),
                ),
              ]);
        });
  }

  captureImageWithCamera() async {
    print("카메라");
    Navigator.pop(context);
    XFile imageFile = await picker.pickImage(
        source: ImageSource.camera, maxWidth: 500, maxHeight: 500);
    setState(() {
      this.files.add(imageFile);
    });
  }

  pickImageFromGallery() async {
    print("갤러리");
    Navigator.pop(context);
    List<XFile> imageFiles =
        await picker.pickMultiImage(maxWidth: 500, maxHeight: 500);
    setState(() {
      this.files.addAll(imageFiles);
    });
  }
}
