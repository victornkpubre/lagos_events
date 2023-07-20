

int eventReadLimit = 5;
List<String> weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

DateTime gMinDate = DateTime(DateTime.now().year - 5, 1, 1);
DateTime gMaxDate = DateTime(DateTime.now().year + 5, 1, 1);

double gMinFee = 0;
double gMaxFee = 100000;

enum Query {
  isEqualTo,
  isNotEqualTo,
  isLessThan,
  isLessThanOrEqualTo,
  isGreaterThan,
  isGreaterThanOrEqualTo,
  isBetween,
  isBetweenArrays,
  isDefault
}