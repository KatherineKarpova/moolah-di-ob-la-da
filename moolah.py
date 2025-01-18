from config import connect_db, get_cursor
from psycopg2.extras import NamedTupleCursor

# I shoulde probably make it so the bills/items I pay for every month are in their own tables

monthly_budgets = {
    "fixed bills", 
    "variable bills",
    "essential misc.",
    "nonessential misc.",        
    "food",
    "clothes",
    "beauty",
    "supplements",
    "cats",
}

def main():
    insert_categories(categories)


def insert_categories(categories):
    # context manager to automate closing
    # using namedtuple is since this is for a list and not a dict
    with connect_db() as conn, conn.cursor(cursor_factory=NamedTupleCursor) as c:
        results = c.execute("""SELECT name FROM categories""").fetchall()
        existing_categories = {row.name for row in results}
        # insert any categories not in the db
        for category in categories:
            if category not in existing_categories:
                c.execute("""INSERT INTO categories (name) VALUES(%s)""", (category,))
        conn.commit()
        

if __name__ == "__main__":
    main()