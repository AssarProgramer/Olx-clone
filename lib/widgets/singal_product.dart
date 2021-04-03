import 'package:flutter/material.dart';

class SingalProduct extends StatelessWidget {
  final String singalProductImage;
  final String singalProductPrice;
  final String singalProductName;
  final String singalProductType;
  final String singalProductTime;
  final Function onTap;
  SingalProduct({
    this.onTap,
    this.singalProductImage,
    this.singalProductName,
    this.singalProductPrice,
    this.singalProductType,
    this.singalProductTime,
  });
  @override
  double height;
  double width;
  Size size;
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        border: Border.all(
          color: Colors.grey,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: height/5,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(singalProductImage ?? ''),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Rs:$singalProductPrice",
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        singalProductName,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        singalProductType,
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                      Text(
                        singalProductTime,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
 
  }
}
