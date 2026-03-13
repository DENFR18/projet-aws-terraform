# Infrastructure AWS Modulaire — Terraform

Infrastructure Cloud complète déployée sur AWS avec Terraform modulaire.
Stack : VPC + EC2 + RDS PostgreSQL + Remote State S3.

## Architecture
```
projet-aws/
├── main.tf              # Orchestration des modules
├── variables.tf         # Variables globales
├── outputs.tf           # IP publique EC2 + endpoint RDS
├── backend.tf           # Remote state S3 + DynamoDB lock
└── modules/
    ├── vpc/             # Réseau (VPC, subnets, IGW, route tables)
    ├── ec2/             # Serveur (instance, SG, key pair)
    └── rds/             # Base de données (PostgreSQL, subnet group)
```

## Stack Technique

| Outil | Usage |
|-------|-------|
| Terraform ~> 5.0 | Infrastructure as Code |
| AWS VPC | Réseau isolé multi-AZ |
| AWS EC2 t3.micro | Serveur applicatif |
| AWS RDS PostgreSQL 15 | Base de données managée |
| AWS S3 | Remote state Terraform |
| AWS DynamoDB | Lock du state (travail en équipe) |

## Fonctionnement des modules

Les modules sont découplés et communiquent via **outputs** :
```
module.vpc → (vpc_id, subnet_ids) → module.ec2
                                  → module.rds
```

Le VPC est créé en premier, EC2 et RDS consomment ses outputs.
Jamais de couplage direct entre modules.

## Utilisation

### Prérequis
- Terraform >= 1.0
- AWS CLI configuré (`aws configure`)
- Clé SSH générée (`~/.ssh/aws_devops.pub`)

### Déploiement
```bash
# 1. Initialiser (télécharge le provider AWS + configure le backend S3)
terraform init

# 2. Vérifier la syntaxe
terraform validate

# 3. Prévisualiser les ressources à créer
terraform plan

# 4. Déployer l'infrastructure
terraform apply

# 5. Détruire l'infrastructure
terraform destroy
```

### Outputs après apply
```bash
ec2_public_ip = "XX.XX.XX.XX"
db_endpoint   = "rds-dev.XXXXX.eu-west-3.rds.amazonaws.com:5432"
```

## Bonnes pratiques appliquées

- **Modules réutilisables** — chaque composant est indépendant
- **Remote state sécurisé** — stocké sur S3 avec versioning et chiffrement
- **DynamoDB lock** — évite les conflits en équipe
- **Variable sensitive** — le mot de passe RDS n'apparaît jamais en clair dans les logs
- **Multi-AZ** — le subnet group RDS couvre 2 zones de disponibilité
- **Tags cohérents** — toutes les ressources taguées avec l'environnement (`dev`, `prod`)

## Auteur

**Denilsson Moreira Pereira** — Mastère DevOps Infrastructure Cloud  
[LinkedIn](https://www.linkedin.com/in/denilsson-moreira-pereira-6b843627a/) · [GitHub](https://github.com/DENFR18)