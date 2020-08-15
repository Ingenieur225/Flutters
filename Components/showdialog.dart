void _showErrorDialog(String message) {
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                title: Text('Une erreur s\'est produite!'),
                content: Text(message),
                actions: <Widget>[
                    FlatButton(
                        child: Text(
                            'Ok', 
                            style: TextStyle(
                                color: Colors.black
                            ),
                        ),
                        onPressed: () {
                            Navigator.of(ctx).pop();
                            setState(() {
                                this.loading = false;
                            });
                        },
                    )
                ],
            ),
        );
    }