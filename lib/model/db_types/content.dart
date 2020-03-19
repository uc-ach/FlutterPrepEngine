part of uc.core;

class Content {
  final String contentType;
  final int contentSubtype;
  final int contentIcon;
  final String snippet;
  final String contentGuid;
  String question;
  String explanation;
  List<Answers> answers;
  int totalAnswers;
  int correctAnswers;
  int seq;
  String correctAnswerStr;
  String specialModuleXml;
  UCItemType _namedContentSubtype;

  Content(this.contentGuid, this.contentType, this.contentSubtype,
      this.contentIcon, this.snippet, String contentText,
      {ignoreParse: false, int randomKey}) {
    if (!ignoreParse) {
      var dartJson = DartJson(contentText);
      if (dartJson.isValid()) {
        var json = dartJson.raw();
        question = json['question'].toString();
        explanation = json['explanation'].toString();
        if (json['answers'] != null) {
          answers = new List<Answers>();
          json['answers'].forEach((v) {
            answers.add(new Answers.fromJson(v));
          });
        }
        totalAnswers = $(json['total_answers']).toInt();
        correctAnswers = $(json['correct_answers']).toInt();
        seq = $(json['seq']).toInt();
        correctAnswerStr = json['correct_answer_str'];
        specialModuleXml = json['special_module_xml'];

        if (true) {
          //for abhishek editor improvements(split text issue in mobile)
          question = question
              .replaceAll(new RegExp(r"&#160;"), ' ')
              .replaceAll('  ', ' &#160;');

          explanation = explanation
              .replaceAll(new RegExp(r"&#160;"), ' ')
              .replaceAll('  ', ' &#160;');
        }

        explanation = explanation.replaceAllMapped(
            new RegExp(r'<seq no="(.)" />'),
            (Match match) =>
                '${match.group(1).toUpperCase()}'); // parse seq tag here

        // todo answer shuffling code
        if ($(randomKey).toBool()) {}
      }
    }
  }

  UCItemType get namedContentSubtype {
    if (_namedContentSubtype == null) {
      _namedContentSubtype = _contentItemsTypes[contentSubtype.toString()];
    }
    return _namedContentSubtype;
  }

  factory Content.fromMap(Map<String, dynamic> data) {
    return Content(
      data['content_guid'].toString(),
      data['content_type'].toString(),
      $(data['content_subtype']).toInt(),
      $(data['content_icon']).toInt(),
      data['snippet'].toString(),
      data['content_text'].toString(),
    );
  }
}

class Answers {
  int isCorrect;
  String answer;
  String id;
  String seqStr;
  String seqTag;

  Answers({this.isCorrect, this.answer, this.id, this.seqStr, this.seqTag});

  Answers.fromJson(Map<String, dynamic> json) {
    isCorrect = $(json['is_correct']).toInt();
    answer = $(json['answer']).toString();
    id = $(json['id']).toString();
    seqStr = $(json['seq_str']).toString();
    seqTag = $(json['seq_tag']).toString();
  }
}
