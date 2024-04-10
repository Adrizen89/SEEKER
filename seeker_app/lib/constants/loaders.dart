import 'package:flutter/material.dart';
import 'package:seeker_app/constants/colors.dart'; // Assurez-vous que le chemin d'accès est correct

class CustomLoader {
  static void showLoadingDialog(BuildContext context,
      {String message = "Chargement en cours..."}) {
    showDialog(
      context: context,
      barrierDismissible:
          false, // L'utilisateur ne peut pas fermer la boîte de dialogue en tapant en dehors
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors
              .transparent, // Rendre l'arrière-plan de la boîte de dialogue transparent
          child: Container(
            decoration: BoxDecoration(
              color:
                  Colors.white, // Utilisez la couleur de fond de votre palette
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(ColorSelect
                      .secondaryColor), // Utilisez la couleur de votre palette
                ),
                SizedBox(height: 15),
                Text(message,
                    style: TextStyle(
                        color: ColorSelect
                            .secondaryColor)), // Utilisez la couleur de votre palette
              ],
            ),
          ),
        );
      },
    );
  }
}
