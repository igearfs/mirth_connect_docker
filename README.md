# Mirth Connect Deployment Architecture

This setup involves two Mirth Connect instances behind HAProxy and Stunnel, connected to a PostgreSQL database. The architecture diagram below illustrates the flow:

![output.png](output.png)

## Components

- **Stunnel**: Handles secure tunneling.
- **HAProxy**: Distributes traffic to the Mirth Connect instances.
- **Mirth Connect Instances**:
  - Mirth Connect 1
  - Mirth Connect 2
- **PostgreSQL**: Database backend for both Mirth Connect instances.
  - The PostgreSQL instance has two databases and schemas. See `startup_files/postgres-init/mc-postgres-init.sql`.
  - Under heavy load, you can separate components and deploy **Stunnel** in front of each `docker-compose` setup.
  - The PostgreSQL + Citus database is set to **master**, allowing additional nodes to be added if needed.
- **Moved Docker passwords and ports to the `.env` file.**

⚠️ **Please change the default passwords before deploying to production.**

## Flow

1. Incoming traffic reaches **Stunnel** for secure tunneling.
2. Traffic is routed to **HAProxy** for load balancing.
3. **HAProxy** directs requests to one of the Mirth Connect instances.
4. Each Mirth Connect instance communicates with the shared **PostgreSQL** database.
5. If the database starts to become overloaded, you can set up a **Citus cluster** for scalability.

---

## ⚠️ Important Warnings

### 1. Do NOT Commit `.env` Files
Your `.env` file contains sensitive credentials. **Ensure it is NOT committed to Git.**  
Add `.env` to `.gitignore` to prevent accidental exposure:

```sh
echo ".env" >> .gitignore
```

If you accidentally commit `.env`, **remove it immediately**:

```sh
git rm --cached .env
git commit -m "Removed sensitive .env file"
git push
```

⚠️ **If credentials were exposed, immediately rotate your secrets.**

---

### 2. Volume Data Persistence Warning
This setup **uses bind mounts (`driver_opts`)** to store persistent data on your host machine.  
All data for PostgreSQL, Mirth Connect, and logs **will be stored in local directories** under `./mc/`.

#### **What This Means**
✅ **Data is saved even if you restart Docker.**  
✅ **You can back up your data easily (by copying the folders).**  
❌ **If you delete the directories manually, your data is gone!**

#### **Backup Instructions**
**To back up your PostgreSQL data manually:**

```sh
tar czf postgres-backup-$(date +%F).tar.gz ./mc/mc-citusdata-postgres-master-data
```

**To restore:**

```sh
tar xzf postgres-backup-YYYY-MM-DD.tar.gz -C ./mc/mc-citusdata-postgres-master-data
```

---

### 3. Running as Root is NOT Recommended
This setup **runs containers as a specific user (`1000:1000`)** for security reasons.  
If you **force root permissions (`sudo`)**, ensure file permissions are correct.

To fix any permission issues:

```sh
sudo chown -R 1000:1000 ./mc/
```

---

### 4. First-Time Setup
After cloning the repository, **set up your environment**:

```sh
cp .env.example .env
nano .env  # Set your credentials
```

Then start the containers:

```sh
docker-compose up -d
```

---

### 📜 License
**© 2024 In-Game Event, A Red Flag Syndicate LLC**  
This program is licensed under the **Server Side Public License (SSPL), version 1**, with additional commercial licensing requirements.

For licensing inquiries, contact:  
📞 [licence_request@igearfs.com](mailto:licence_request@igearfs.com)

---

## 💡 Need Help?
If you encounter issues, check logs with:

```sh
docker-compose logs -f
```

For additional support, open an issue or contact us at:  
📞 [contact@igearfs.com](mailto:contact@igearfs.com)

---

## No Warranty

This program is distributed in the hope that it will be useful, but **WITHOUT ANY WARRANTY**; without even the implied warranty of **MERCHANTABILITY** or **FITNESS FOR A PARTICULAR PURPOSE**.

For licensing inquiries, contact:
- **License Requests**: [licence_request@igearfs.com](mailto:licence_request@igearfs.com)
- **General Inquiries**: [contact@igearfs.com](mailto:contact@igearfs.com)

For more details, refer to the full text of the **Server Side Public License (SSPL)** at [https://www.mongodb.com/licensing/server-side-public-license](https://www.mongodb.com/licensing/server-side-public-license).

