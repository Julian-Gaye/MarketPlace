// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract MarketPlace {
  struct Produit {
    uint id;
    string name;
    State etat;
  }

  Produit[] produits;
  
  address private acheteur;
  address private vendeur;
  mapping (address => uint) private balances;

  event ListProduits(Produit[] produit);
  event ProduitsAchetes(address acheteur, address vendeur, uint prix, uint id);

  enum State { ProduitDisponible, ArticleCommande }

  constructor() {
      vendeur = msg.sender;
      produits.push(Produit(0, "Produit1", State.ProduitDisponible));
      produits.push(Produit(1, "Produit2", State.ProduitDisponible));
      produits.push(Produit(2, "Produit3", State.ProduitDisponible));
      emit ListProduits(produits);
  }

  function achat(address _vendeur, address _acheteur, uint _prix, uint _id) public payable {
    require(balances[_acheteur] >= _prix, "L'acheteur n'a pas assez d'argent");
    require(_id <= produits.length, "Le produit n'existe pas");
    require(produits[_id].etat == State.ProduitDisponible, "Le produit n'est pas disponible");
    balances[_vendeur] += _prix;
    balances[_acheteur] -= _prix;
    produits[_id].etat = State.ArticleCommande;
    emit ProduitsAchetes(_acheteur, _vendeur, _prix, _id);
  }

  function getSolde(address _acheteur) public view returns(uint) {
    return(balances[_acheteur]);
  }

  function setSolde(address _acheteur, uint _montant) public {
      balances[_acheteur] = _montant;
  }

  function getListeProduits() public {
      emit ListProduits(produits);
  }
}
