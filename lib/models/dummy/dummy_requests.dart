import '../product/product.dart';
import '../product/product_type.dart';
import '../request/request.dart';
import '../request/request_status.dart';
import '../user/user.dart';
import '../product/category.dart';

class DummyRequestProvider {
  static final List<Request> _requests = [
    Request(
      id: '1',
      user: User(
        id: '1',
        name: 'John Doe',
        email: 'john.doe@example.com',
        phone: '+1234567890',
        address: '123 Main Street',
        profileImageUrl: 'https://i.pravatar.cc/150?img=1',
        size: 'L',
        shoeSize: 10,
      ),
      clerk: User(
        id: '2',
        name: 'Jane Smith',
        email: 'jane.smith@example.com',
        phone: '+0987654321',
        address: '456 Main Street',
        profileImageUrl: 'https://i.pravatar.cc/150?img=2',
        size: 'M',
        shoeSize: 8,
      ),
      products: [
        Product(
          id: '2',
          title: 'Blue Jeans',
          price: 29.99,
          imageUrl: 'https://i.pravatar.cc/150?img=4',
          description: 'These are blue jeans made of 99% cotton and 1% spandex',
          categories: [ItemCategory.Men, ItemCategory.Bottoms],
          type: ProductType.Clothing,
          stock: 100,
          rating: 4.5,
          brand: 'Levis',
          material: 'Cotton',
          color: 'Blue',
          size: '32',
          gender: 'Men',
          madeIn: 'USA',
        ),
        Product(
          id: '3',
          title: 'Black Sneakers',
          price: 89.99,
          imageUrl: 'https://i.pravatar.cc/150?img=5',
          description:
              'These are black sneakers made of synthetic material and have a rubber sole',
          categories: [ItemCategory.Men, ItemCategory.Shoes],
          type: ProductType.Shoes,
          stock: 20,
          rating: 4,
          brand: 'Nike',
          material: 'Synthetic',
          color: 'Black',
          size: '9',
          gender: 'Men',
          madeIn: 'China',
        ),
      ],
      message: 'Could you add a gift wrapping for these items, please?',
      status: RequestStatus.pending,
    ),
    Request(
      id: '100',
      user: User(
        id: '1',
        name: 'John Doe',
        email: 'john.doe@example.com',
        phone: '+1234567890',
        address: '123 Main Street',
        profileImageUrl: 'https://i.pravatar.cc/150?img=1',
        size: 'L',
        shoeSize: 10,
      ),
      clerk: User(
        id: '2',
        name: 'Jane Smith',
        email: 'jane.smith@example.com',
        phone: '+0987654321',
        address: '456 Main Street',
        profileImageUrl: 'https://i.pravatar.cc/150?img=2',
        size: 'M',
        shoeSize: 8,
      ),
      products: [
        Product(
          id: '-NEPxPT8F5BFAZbWokNb',
          title: 'Blue T-Shirt',
          price: 29.99,
          imageUrl: 'https://i.pravatar.cc/150?img=4',
          description: 'These are blue jeans made of 99% cotton and 1% spandex',
          categories: [ItemCategory.Men, ItemCategory.Bottoms],
          type: ProductType.Clothing,
          stock: 100,
          rating: 4.5,
          brand: 'Levis',
          material: 'Cotton',
          color: 'Blue',
          size: '32',
          gender: 'Men',
          madeIn: 'USA',
        ),
        Product(
          id: '-MEPxPT8F5BFAZbWokNc',
          title: 'Black Shirt',
          price: 89.99,
          imageUrl: 'https://i.pravatar.cc/150?img=5',
          description:
              'These are black sneakers made of synthetic material and have a rubber sole',
          categories: [ItemCategory.Men, ItemCategory.Shoes],
          type: ProductType.Shoes,
          stock: 20,
          rating: 4,
          brand: 'Nike',
          material: 'Synthetic',
          color: 'Black',
          size: '9',
          gender: 'Men',
          madeIn: 'China',
        ),
      ],
      message: 'Could you add a gift wrapping for these items, please?',
      status: RequestStatus.pending,
    ),
  ];

  get getRequests => _requests;
}
