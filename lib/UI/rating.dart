import 'package:flutter/material.dart';

class RatingIndicator extends StatefulWidget {
  double rating;
  RatingIndicator(this.rating);
  _RatingIndicatorState createState() => _RatingIndicatorState();
}

class _RatingIndicatorState extends State<RatingIndicator> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          widget.rating.toString(),
          style: TextStyle(
              color: (Colors.orange),
              fontStyle: FontStyle.italic,
              fontSize: 20.0),
        ),
        Row(
          children: <Widget>[
            (widget.rating > 0.5)
                ? Icon(
                    Icons.star,
                    color: Colors.orange,
                    size: 20,
                  )
                : (widget.rating > 0)
                    ? Icon(
                        Icons.star_half,
                        color: Colors.orange,
                        size: 20,
                      )
                    : Icon(
                        Icons.star_border,
                        color: Colors.orange,
                        size: 20,
                      ),
            (widget.rating > 1.5)
                ? Icon(
                    Icons.star,
                    color: Colors.orange,
                    size: 20,
                  )
                : (widget.rating > 1)
                    ? Icon(
                        Icons.star_half,
                        color: Colors.orange,
                        size: 20,
                      )
                    : Icon(
                        Icons.star_border,
                        color: Colors.orange,
                        size: 20,
                      ),
            (widget.rating > 2.5)
                ? Icon(
                    Icons.star,
                    color: Colors.orange,
                    size: 20,
                  )
                : (widget.rating > 2)
                    ? Icon(
                        Icons.star_half,
                        color: Colors.orange,
                        size: 20,
                      )
                    : Icon(
                        Icons.star_border,
                        color: Colors.orange,
                        size: 20,
                      ),
            (widget.rating > 3.5)
                ? Icon(
                    Icons.star,
                    color: Colors.orange,
                    size: 20,
                  )
                : (widget.rating > 3)
                    ? Icon(
                        Icons.star_half,
                        color: Colors.orange,
                        size: 20,
                      )
                    : Icon(
                        Icons.star_border,
                        color: Colors.orange,
                        size: 20,
                      ),
            (widget.rating > 4.5)
                ? Icon(
                    Icons.star,
                    color: Colors.orange,
                    size: 20,
                  )
                : (widget.rating > 4)
                    ? Icon(
                        Icons.star_half,
                        color: Colors.orange,
                        size: 20,
                      )
                    : Icon(
                        Icons.star_border,
                        color: Colors.orange,
                        size: 20,
                      ),
          ],
        )
      ],
    );
  }
}
