//
//  TermsAndConditionsView.swift
//  EasyParty
//
//  Created by Hugues Fils on 10/06/2024.
//

import SwiftUI

public struct TermsAndConditionsView: View {
    public init() {}
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                
                Text("1. Acceptation des Termes")
                    .font(.headline)
                Text("En téléchargeant, installant ou utilisant EasyParty, vous acceptez d'être lié par ces termes et conditions. Si vous n'acceptez pas ces termes, veuillez ne pas utiliser l'application.")
                
                Text("2. Description du Service")
                    .font(.headline)
                Text("EasyParty est une application mobile qui permet aux utilisateurs de créer, partager et participer à des fêtes. Les principales fonctionnalités incluent :")
                Text("• Création de comptes utilisateurs.")
                Text("• Gestion des événements et des fêtes.")
                Text("• Téléchargement et partage d'images.")
                
                Text("3. Données Enregistrées")
                    .font(.headline)
                Text("Les seules données enregistrées dans notre base de données sont les suivantes :")
                Text("• Identifiants des utilisateurs (nom d'utilisateur, adresse e-mail, etc.).")
                Text("• Informations sur les fêtes (détails des événements, date, lieu, etc.).")
                Text("• Images téléchargées par les utilisateurs.")
                
                Text("4. Suppression des Comptes et Données")
                    .font(.headline)
                Text("Les utilisateurs ont la possibilité de supprimer leur compte ainsi que toutes leurs données associées directement via l'application EasyParty. La suppression des données est immédiate et irréversible.")
                
                Text("5. Confidentialité")
                    .font(.headline)
                Text("Nous nous engageons à protéger la confidentialité de vos informations personnelles. Les données enregistrées ne seront ni vendues ni partagées avec des tiers sans votre consentement explicite.")
                
                Text("6. Utilisation de l'Application")
                    .font(.headline)
                Text("En utilisant EasyParty, vous acceptez de :")
                Text("• Fournir des informations véridiques et à jour lors de la création de votre compte.")
                Text("• Ne pas utiliser l'application pour des activités illégales ou non autorisées.")
                Text("• Respecter les droits des autres utilisateurs.")
                
                Text("7. Propriété Intellectuelle")
                    .font(.headline)
                Text("Tous les droits de propriété intellectuelle relatifs à l'application EasyParty et son contenu sont la propriété exclusive de EasyParty ou de ses concédants. Toute reproduction ou redistribution du contenu sans autorisation préalable est interdite.")
                
                Text("8. Limitation de Responsabilité")
                    .font(.headline)
                Text("EasyParty n'est pas responsable des dommages directs, indirects, accessoires ou consécutifs résultant de l'utilisation ou de l'incapacité à utiliser l'application. L'application est fournie \"en l'état\" sans garantie d'aucune sorte.")
                
                Text("9. Modifications des Termes")
                    .font(.headline)
                Text("EasyParty se réserve le droit de modifier ces termes et conditions à tout moment. Les modifications seront publiées sur cette page et entreront en vigueur immédiatement après leur publication. Il est de votre responsabilité de consulter régulièrement ces termes pour être informé des éventuelles modifications.")
                
                Text("10. Contact")
                    .font(.headline)
                Text("Pour toute question concernant ces termes et conditions, veuillez nous contacter à support@easyparty.com.")
                
                Text("En utilisant EasyParty, vous reconnaissez avoir lu et compris ces termes et conditions et acceptez d'être lié par eux.")
                
                Text("Merci d'utiliser EasyParty !")
                    .padding(.top, 10)
            }
            .padding()
        }
        .background(Color.ds.customBackground)
        .navigationBarTitle("Termes et Conditions", displayMode: .inline)
    }
}

#Preview {
    TermsAndConditionsView()
}
