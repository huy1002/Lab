import 'dart:async';
import 'dart:io';

void main() {
  ex1();
  ex2();
  ex3();
  ex4();
  ex5();
}

void ex1(){
  print('Exercise 1 :');
  int age = 21;
  double height = 1.7;
  String name = 'Huy';
  bool isStudent = true;

  print('Name: $name');
  print('Age: $age');
  print('Height: $height m');
  print('Is student: $isStudent');
  print('Next year age: ${age + 1}');
  print('______________________');
}
void ex2(){
  print('Exercise 2:');

  List<int> num =[1,2,3,4,5];
  print('$num');
print('First number :${num[0]}');

  int S = num[0] + num[3];
  int D = num[2] - num[0];
  print('${num[0]} + ${num[3]} = $S');
  print('${num[2]} - ${num[0]} = $D');

  print('Is 3 smaller than 4? ${3 < 4}');

  num.add(6);
  num.remove(1);
  print('List after add/remove: $num');

  Set<int> numbers = {1, 2, 2, 3, 4, 4};
  print('Set : $numbers');
  numbers.remove(1);
  print('Set New: $numbers');

 Map<String,dynamic> map = {
   'Name':'Huy',
   'Age':21,
   'Handsome':true,
 };
 print('Name : ${map['Name']}');
 print('Age: ${map['Age']}');
 print('Huy is Handsome? ${map['Handsome']}');
 print('________________________');
}

void ex3(){

print('Exercise 3 :');

int score=9;
print('$score');

if(score>=8){
  print('good');
}

else if(score>5 ){
  print('passed');
}

else if( score < 5){
  print('failed');
}



int day = 3;
print('day $day of week is :');
switch (day) {
  case 1:
    print('月曜日');
    break;
  case 2:
    print('火曜日');
    break;
  case 3:
    print('水曜日');
    break;
  case 4:
    print('木曜日');
    break;
  case 5:
    print('金曜日');
    break;
  case 6:
    print('土曜日');
    break;
  case 7:
    print('日曜日');
    break;
  default:
    print('Invalid day');
}

List<int> list = [1,3,5,7,9,11];

print('for loop:');
for(int i=0;i<list.length;i++){
stdout.write('${list[i]} ');
}
print('');


  print('for-in loop:');
  for (int list in list) {
    stdout.write('$list ');
  }
print('');


  print('forEach loop:');
  list.forEach((list) {
    stdout.write('$list ');
  });
print('');

int a=3,b=6;

int sum(int a, int b){
  return a+b;
}

int SUM(int a,int b)=> a+b;

int s1=sum(a,b);
int s2=SUM(a,b);
print('a + b = $s1 = $s2');

print('____________________');

}
void ex4(){

  print('Exercise 4 :');
  Car car1 = Car('Toyota');
  Car car2 = Car.withBrand('Honda');
  ElectricCar car3 = ElectricCar('Tesla');
  print(car3.carBrand());

  print(car1.carBrand());
  print(car2.carBrand());
  print(car3.carBrand());

  print('____________________________');
}

class Car {
  String brand;
  Car(this.brand);
  Car.withBrand(this.brand);
  String carBrand () {
    return 'This is a $brand car.';
  }
}

class ElectricCar extends Car {
  ElectricCar(String brand) : super(brand);
  @override
  String carBrand() {
    return 'This is a $brand electric car.';
  }
}


void ex5() async {
  print('Exercise 5:');

  String data = await loadData();
  print(' $data ');

  //  ? allows a variable to contain null.
  String? nickname;

  // ?? provides a default value when the variable is null.
  String displayName = nickname ?? 'Guest';
  print('Display name: $displayName');

  // ! tells Dart that the value is not null.
  String message = 'Hehehehe';
  print('Message length: ${message!.length}');

  // Create a simple Stream of integers.
  Stream<int> numberStream = Stream.fromIterable([0, 2, 4, 6, 8]);

  print('Stream values:');

  // Listen to each value emitted by the stream.
  await numberStream.listen((value) {
    print('  Received: $value');
  }).asFuture<void>();

  print('Stream completed.');

}

// Async function using Future and await.
Future<String> loadData() async {
  print('Loading data...');
  await Future.delayed(const Duration(seconds: 3));
  print('wait me a sec....');
  await Future.delayed(const Duration(seconds: 2));
  return 'Data loaded successfully!';
}

