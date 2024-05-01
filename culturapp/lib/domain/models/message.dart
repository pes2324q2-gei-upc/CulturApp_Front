class Message {
  String text;
  String sender;
  String timeSended;

  Message({required this.text, required this.sender, required this.timeSended});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
        text: json['mensaje'],
        sender: json['senderId'],
        timeSended: json['fecha']);
  }
}

List<Message> allMessage = [
  Message(text: 'text', sender: 'Rosa', timeSended: '10:00'),
  Message(
      text: 'text llarggggggggggggggggggg',
      sender: 'Rosa',
      timeSended: '10:00'),
  Message(text: 'text', sender: 'Me', timeSended: '10:00'),
  Message(text: 'text', sender: 'Rosa', timeSended: '10:00'),
  Message(text: 'text', sender: 'Me', timeSended: '10:00'),
  Message(text: 'text', sender: 'Rosa', timeSended: '10:00'),
  Message(text: 'text', sender: 'Me', timeSended: '10:00'),
  Message(text: 'text', sender: 'Rosa', timeSended: '10:00'),
  Message(text: 'text', sender: 'Andreu', timeSended: '10:00'),
];

List<Message> allMessageDuo = [
  Message(text: 'text', sender: 'Rosa', timeSended: '10:00'),
  Message(text: 'text', sender: 'Rosa', timeSended: '10:00'),
  Message(text: 'text', sender: 'Andreu', timeSended: '10:00'),
];

List<Message> missatgesAmic = [
  Message(text: 'text', sender: 'Amic', timeSended: '10:00'),
  Message(
      text: 'text llarggggggggggggggggggg',
      sender: 'Amic',
      timeSended: '10:00'),
  Message(text: 'text', sender: 'Me', timeSended: '10:00'),
  Message(text: 'text', sender: 'Amic', timeSended: '10:00'),
  Message(text: 'text', sender: 'Me', timeSended: '10:00'),
  Message(text: 'text', sender: 'Amic', timeSended: '10:00'),
  Message(text: 'text', sender: 'Me', timeSended: '10:00'),
  Message(text: 'text', sender: 'Amic', timeSended: '10:00'),
];