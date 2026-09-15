class CreateCoreSchema < ActiveRecord::Migration[7.2]
  def change
    # Routes
    create_table :routes do |t|
      t.string :origin, null: false
      t.string :destination, null: false
      t.timestamps
    end

    # Buses
    create_table :buses do |t|
      t.references :owner, null: false, foreign_key: { to_table: :users }
      t.string :name, null: false
      t.string :plate_number, null: false
      t.integer :total_seats, null: false
      t.jsonb :layout_json
      t.timestamps
    end

    add_index :buses, :plate_number, unique: true

    # Seats
    create_table :seats do |t|
      t.references :bus, null: false, foreign_key: true
      t.string :seat_number, null: false
      t.timestamps
    end

    add_index :seats, [:bus_id, :seat_number], unique: true

    # Schedules
    create_table :schedules do |t|
      t.references :bus, null: false, foreign_key: true
      t.references :route, null: false, foreign_key: true
      t.datetime :departure_time, null: false
      t.datetime :arrival_time, null: false
      t.decimal :fare, precision: 10, scale: 2, null: false
      t.timestamps
    end

    # Bookings
    create_table :bookings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :schedule, null: false, foreign_key: true
      t.integer :status, null: false, default: 0   # pending/confirmed/cancelled
      t.timestamps
    end

    # Booking <-> Seat join table
    create_table :booking_seats do |t|
      t.references :booking, null: false, foreign_key: true
      t.references :seat, null: false, foreign_key: true
      t.timestamps
    end

    add_index :booking_seats, [:booking_id, :seat_id], unique: true

    # Payments
    create_table :payments do |t|
      t.references :booking, null: false, foreign_key: true
      t.string :stripe_payment_intent_id, null: false
      t.integer :amount_cents, null: false
      t.integer :status, null: false, default: 0   # pending/succeeded/refunded/failed
      t.string :stripe_refund_id
      t.timestamps
    end
  end
end
