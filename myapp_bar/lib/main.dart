import 'package:flutter/material.dart';

/**
 * 커스텀 앱바를 작성하는 플루터 예제
 */
//void main() => runApp(MaterialApp(
//  title: 'My app',
//  home: MyScaffold(),
//));
//
//class MyAppBar extends StatelessWidget {
//  MyAppBar({this.title});
//
//  // 위젯 서브클래스의 필드들은 final로 선언되어야 함
//  final Widget title;
//
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      height: 56.0,   // logical pixels
//      padding: const EdgeInsets.symmetric(horizontal: 8.0),
//      decoration: BoxDecoration(color: Colors.blue[500]),
//      // Row is a horizontal, linear layout
//      child: Row(
//        // <Widget>은 리스트에서 아이템의 타입
//        children: <Widget>[
//          IconButton(
//            icon: Icon(Icons.menu),
//            tooltip: 'Navigation menu',
//            onPressed: null,
//          ),
//          // Expanded expands its child to fill the available space
//          Expanded(
//            child: title,
//          ),
//          IconButton(
//            icon: Icon(Icons.search),
//            tooltip: 'Search',
//            onPressed: null,
//          )
//        ],
//      ),
//    );
//  }
//}
//
//class MyScaffold extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    // Material is a conceptual piece of paper on which the UI appears.
//    return Material(
//      // Column is a vertical, linear layout
//      child: Column(
//        children: <Widget>[
//          MyAppBar(
//            title: Text('Example title',
//            style: Theme.of(context).primaryTextTheme.title,),
//          ),
//          Expanded(
//            child: Center(
//              child: Text('Hello, world!'),
//            ),
//          )
//        ],
//      ),
//    );
//  }
//}

// Material 요소 적용 demo
void main() {
//  runApp(MaterialApp(
//    title: 'Flutter Tutorial',
//    home: TutorialHome(),
//  ));
  runApp(MaterialApp(
    title: 'Shopping App',
    home: ShoppingList(
      products: <Product>[
        Product(name: 'Eggs'),
        Product(name: 'Flour'),
        Product(name: 'Chocolate chips'),
      ],
    ),
  ));
}

class TutorialHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Scaffold는 주요 머터리얼 요소를 위한 레이아웃 골격
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          tooltip: 'Navigation menu',
          onPressed: null,
        ),
        title: Text('Example title'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            tooltip: 'Search',
            onPressed: null,
          )
        ],
      ),
      // body는 스크린의 앱바를 제외한 전체화면
      body: Center(
        //child: Text('Hello Flutter!!!'),
        //child: MyButton(),
        child: Counter(),
      ),
      floatingActionButton: FloatingActionButton(
          tooltip: 'Add', child: Icon(Icons.add), onPressed: null),
    );
  }
}

// Handling gestures
class MyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('MyButton was tapped!');
      },
      child: Container(
        height: 36.0,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.lightGreen[500],
        ),
        child: Center(
          child: Text('Engage'),
        ),
      ),
    );
  }
}

// changing widgets in response to Input
class Counter extends StatefulWidget {

  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int _counter = 0;

  void _increment() {
    setState(() {
      ++_counter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
//        RaisedButton(
//          onPressed: _increment,
//          child: Text('Increment'),
//        ),
//        Text('Count: $_counter'),
          CounterIncrementer(onPressed: _increment),
          CounterDisplay(count: _counter),
      ],
    );
  }

}

// 결합성과 복잡도를 낮추기 위한 분리
class CounterDisplay extends StatelessWidget {
  CounterDisplay({this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Text('Count: $count');
  }
}

class CounterIncrementer extends StatelessWidget {
  CounterIncrementer({this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      child: Text('Increment'),
    );
  }
}

// Bringing it all together
class Product {
  const Product({this.name});
  final String name;
}

typedef void CartChangedCallback(Product product, bool inCart);

class ShoppingListItem extends StatelessWidget {
  ShoppingListItem({Product product, this.inCart, this.onCartChanged})
      : product = product,
        super(key: ObjectKey(product));
  final Product product;
  final bool inCart;
  final CartChangedCallback onCartChanged;

  Color _getColor(BuildContext context) {
    return inCart ? Colors.black54 : Theme.of(context).primaryColor;
  }

  TextStyle _getTextStyle(BuildContext context) {
    if (!inCart) return null;

    return TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onCartChanged(product, !inCart);
      },
      leading: CircleAvatar(
        backgroundColor: _getColor(context),
        child: Text(product.name[0]),
      ),
      title: Text(product.name, style: _getTextStyle(context)),
    );
  }
}

// parent widget that stores mutable state
class ShoppingList extends StatefulWidget {
  ShoppingList( { Key key, this.products} ) : super(key: key);

  final List<Product> products;

  @override
  _ShoppingListState createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  Set<Product> _shoppingCart = Set<Product>();

  void _handleCartChanged(Product product, bool inCart) {
    setState(() {
      if (inCart)
        _shoppingCart.add(product);
      else
        _shoppingCart.remove(product);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping List'),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        children: widget.products.map((Product product) {
          return ShoppingListItem(
            product: product,
            inCart: _shoppingCart.contains(product),
            onCartChanged: _handleCartChanged,
          );
        }).toList(),
      ),
    );
  }
}
