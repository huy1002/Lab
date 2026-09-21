
void main() {

  Car car = Car('Honda', 2022, false);
  car.startEngine();

  Car tesla = Car.tesla(2025);
  tesla.startEngine();
}

class Vehicle {
  String brand;
  int year;

  Vehicle(this.brand, this.year);
  void startEngine() {
    print('Khởi động phương tiện...');
  }
}


class Car extends Vehicle {
  bool isElectric;

  Car(String brand, int year, this.isElectric)
      : super(brand, year);

  Car.tesla(int year)
      : isElectric = true,
        super('Teslaaa', year);

  @override
  void startEngine() {
    if (isElectric) {
      print('$brand $year: Khởi động xe điện...');
    } else {
      print('$brand $year: Khởi động động cơ xăng...');
    }
  }
}