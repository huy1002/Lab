
import 'dart:async';
import 'dart:convert';

Future<void> main() async {

  await exercise1();
  await exercise2();
  await exercise3();
  await exercise4();
  exercise5();

}


class Product {
  final int id;
  final String name;
  final double price;

  Product(this.id, this.name, this.price);

  @override
  String toString() {
    return 'Product(id: $id, name: $name, price: \$${price.toStringAsFixed(2)})';
  }
}

class ProductRepository {
  final StreamController<Product> _controller =
  StreamController<Product>.broadcast();

  Future<List<Product>> getAll() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      Product(1, 'Laptop', 1200.0),
      Product(2, 'Mouse', 25.0),
      Product(3, 'Keyboard', 50.0),
    ];
  }


  Stream<Product> liveAdded() {
    return _controller.stream;
  }


  void addProduct(Product product) {
    _controller.add(product);
  }

  void dispose() {
    _controller.close();
  }
}

Future<void> exercise1() async {
  print('--- Exercise 1: Product Model & Repository ---');

  final repository = ProductRepository();

  // Get products using Future.
  final products = await repository.getAll();

  print('All products:');
  for (final product in products) {
    print('  $product');
  }


  final subscription = repository.liveAdded().listen((product) {
    print('New product received: $product');
  });


  repository.addProduct(Product(4, 'Monitor', 300.0));


  await Future.delayed(const Duration(milliseconds: 100));

  await subscription.cancel();
  repository.dispose();

  print('');
}


class User {
  final String name;
  final String email;

  User(this.name, this.email);

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'];

  @override
  String toString() {
    return 'User(name: $name, email: $email)';
  }
}

class UserRepository {
  Future<List<User>> getUsers() async {
    await Future.delayed(const Duration(milliseconds: 500));


    const jsonData = '''
    [
      {"name": "Huy", "email": "huy@example.com"},
      {"name": "An", "email": "an@example.com"},
      {"name": "Minh", "email": "minh@example.com"}
    ]
    ''';


    final List<dynamic> decodedData = jsonDecode(jsonData);

    return decodedData
        .map((json) => User.fromJson(json))
        .toList();
  }
}

Future<void> exercise2() async {
  print('--- Exercise 2: User Repository with JSON ---');

  final repository = UserRepository();

  final users = await repository.getUsers();

  print('Users from JSON:');

  for (final user in users) {
    print('  $user');
  }

  print('');
}


Future<void> exercise3() async {
  print('--- Exercise 3: Async + Microtask Debugging ---');

  print('1. Synchronous code');


  scheduleMicrotask(() {
    print('2. Microtask');
  });


  Future(() {
    print('4. Future event');
  });

  print('3. More synchronous code');

  await Future.delayed(const Duration(milliseconds: 100));

  print(
    'Explanation: Synchronous code runs first, '
        'then microtasks, then event queue callbacks.',
  );

  print('');
}


Future<void> exercise4() async {
  print('--- Exercise 4: Stream Transformation ---');

  final numberStream = Stream.fromIterable([1, 2, 3, 4, 5]);

  final transformedStream = numberStream
      .map((number) => number * number)
      .where((number) => number % 2 == 0);

  print('Even squares:');

  await for (final value in transformedStream) {
    print('  $value');
  }

  print('');
}

class Settings {

  static final Settings _instance = Settings._internal();

  Settings._internal();


  factory Settings() {
    return _instance;
  }

  String theme = 'Dark';
  String language = 'English';
}

void exercise5() {
  print('--- Exercise 5: Factory Constructors & Cache ---');

  final settingsA = Settings();
  final settingsB = Settings();

  print('Settings A theme: ${settingsA.theme}');
  print('Settings B theme: ${settingsB.theme}');

  print('Are A and B the same object? ${identical(settingsA, settingsB)}');

  print('');
}