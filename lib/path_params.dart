class PATHParams {
  List<String> routes;
  List<Map<String, dynamic>> listRegExp = [];
  PATHParams(this.routes) {
    for (var ele in routes) {
      listRegExp
          .add({'regexp': ele.replaceAll(RegExp('<.*>'), '.*'), 'value': ele});
    }
  }

  String getIsMatchString(String path) {
    String toPath = path[path.length - 1] == '/' ? path : (path + '/');
    String target = '';
    for (var item in listRegExp) {
      if (RegExp(item['regexp']).hasMatch(toPath)) {
        target = item['value'];
        break;
      }
    }
    return target;
  }

  Map<String, dynamic> getValues(String path) {
    String toPath = path[path.length - 1] == '/' ? path : (path + '/');
    String regText = '';
    for (Map<String, dynamic> item in listRegExp) {
      if (item['regexp'] != null) {
        if (RegExp(item['regexp']).hasMatch(path)) {
          regText = item['regexp'];
        }
      }
    }
    Map<String, dynamic> values = {};
    List<String> valuesList = toPath.split('/');
    List<String> targetList = regText.split('/');
    if (valuesList.length != targetList.length) {
      return {};
    } else {
      for (int i = 0; i < targetList.length; i++) {
        if (targetList[i] != valuesList[i]) {
          values[targetList[i].replaceAll(RegExp('<|>'), '')] = valuesList[i];
        }
      }
      return values;
    }
  }
}
