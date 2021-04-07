import 'package:clay_containers/widgets/clay_container.dart';
import 'package:extended_image/extended_image.dart';
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

    return ClayContainer(
      color: Theme.of(context).primaryColor,
      depth: 40,
      spread: 1,
      borderRadius: 10,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 7,
          horizontal: 7,
        ),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ExtendedImage.network(
            //   singalProductImage,
            //   height: 100,
            //   fit: BoxFit.fill,
            //   cache: true,
            //   border: Border.all(color: Colors.red, width: 1.0),
            //   borderRadius: BorderRadius.all(Radius.circular(30.0)),
            //   //cancelToken: cancellationToken,
            // ),
            ClayContainer(
              color: Theme.of(context).primaryColor,
              borderRadius: 10,
              emboss: true,
              child: Container(
                height: height / 5,
                child: GestureDetector(
                  onTap: onTap,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      
                      borderRadius: BorderRadius.circular(10),
                      // image: DecorationImage(
                      //     fit: BoxFit.cover,
                      //     image: NetworkImage(singalProductImage),
                      //     onError: (assr, sdsa) {
                      //       if (sdsa == null) {
                      //         return CircularProgressIndicator(backgroundColor: Colors.red,);
                      //       }
                      //     }),6
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        singalProductImage,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadding) {
                          return loadding == null
                              ? child
                              : Center(
                                  child: CircularProgressIndicator(),
                                );
                        },
                      ),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Rs:$singalProductPrice",
                          style: TextStyle( 
                              color: Colors.black, fontWeight: FontWeight.bold
                              // fontSize: 20
                              ),
                        ),
                        Text(
                          singalProductType,
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                            // fontSize: 12
                          ),
                        ),
                      ],
                    ),
                    // SizedBox(
                    //   height: 5,
                    // ),
                    Text(
                      singalProductName,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Color(0xFF695E5E)),
                    ),
                    //  SizedBox(
                    //   height: 5,
                    // ),
                    Text(
                      singalProductTime,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
