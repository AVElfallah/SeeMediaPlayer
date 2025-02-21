import 'package:see_media_player/data/models/information.dart';

class Sorting<T> {
  Sorting() : assert(T is! List<MediaInformation>);

  List<T> sort(List<T> list, {required SortingType type, SortingOrder? order}) {
    switch (type) {
      case SortingType.date:
        return _sortByDate(list, order ?? SortingOrder.asc);
      case SortingType.name:
        return _sortByName(list, order ?? SortingOrder.asc);
      case SortingType.size:
        return _sortBySize(list, order ?? SortingOrder.asc);
      case SortingType.duration:
        return _sortByDuration(list, order ?? SortingOrder.asc);
    }
  }

  List<T> _sortByDate(List<T> list, SortingOrder order) {
    (list as List<MediaInformation>).sort((a, b) {
      var aDate = DateTime.parse(a.date!);
      var bDate = DateTime.parse(b.date!);
      return aDate.compareTo(bDate);
    });
    return order == SortingOrder.asc ? list : list.reversed.toList();
  }

  List<T> _sortByName(List<T> list, SortingOrder order) {
    (list as List<MediaInformation>).sort((a, b) {
      var aName = a.name!;
      var bName = b.name!;
      return aName.compareTo(bName);
    });
    return order == SortingOrder.asc ? list : list.reversed.toList();
  }

  List<T> _sortBySize(List<T> list, SortingOrder order) {
    (list as List<MediaInformation>).sort((a, b) {
      var aSize = double.parse(a.size!);
      var bSize = double.parse(b.size!);
      return aSize.compareTo(bSize);
    });
    return order == SortingOrder.asc ? list : list.reversed.toList();
  }

  List<T> _sortByDuration(List<T> list, SortingOrder order) {
    (list as List<MediaInformation>).sort((a, b) {
      var aDuration = a.duration!.length == 5
          ? Duration(
              seconds: int.parse(
                a.duration!.substring(3),
              ),
              minutes: int.parse(
                a.duration!.substring(0, 2),
              ),
            )
          : Duration(
              seconds: int.parse(a.duration!.substring(6)),
              minutes: int.parse(
                a.duration!.substring(3, 5),
              ),
              hours: int.parse(
                a.duration!.substring(0, 2),
              ),
            );
      var bDuration = b.duration!.length == 5
          ? Duration(
              seconds: int.parse(
                b.duration!.substring(3),
              ),
              minutes: int.parse(
                b.duration!.substring(0, 2),
              ),
            )
          : Duration(
              seconds: int.parse(b.duration!.substring(6)),
              minutes: int.parse(
                b.duration!.substring(3, 5),
              ),
              hours: int.parse(
                b.duration!.substring(0, 2),
              ),
            );
      return aDuration.compareTo(bDuration);
    });
    return order == SortingOrder.asc ? list : list.reversed.toList();
  }
}

enum SortingType {
  date,
  name,
  size,
  duration,
}

enum SortingOrder {
  asc,
  dsc,
}
