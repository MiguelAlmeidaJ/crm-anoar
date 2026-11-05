<?php
declare(strict_types=1);

namespace Anoar\Crm;

use PDO;
use InvalidArgumentException;

final class ContactRepository
{
    public function __construct(private readonly PDO $db, private readonly int $tenantId)
    {
        if ($tenantId <= 0) {
            throw new InvalidArgumentException('Tenant inválido');
        }
    }

    public function all(int $limit = 50, int $offset = 0): array
    {
        $stmt = $this->db->prepare(
            'SELECT id, name, email, phone, company, temperature, source, created_at
             FROM contacts WHERE tenant_id = :tenant_id ORDER BY id DESC LIMIT :limit OFFSET :offset'
        );
        $stmt->bindValue(':tenant_id', $this->tenantId, PDO::PARAM_INT);
        $stmt->bindValue(':limit', max(1, min($limit, 100)), PDO::PARAM_INT);
        $stmt->bindValue(':offset', max(0, $offset), PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll();
    }

    public function find(int $contactId): ?array
    {
        $stmt = $this->db->prepare(
            'SELECT * FROM contacts WHERE tenant_id = :tenant_id AND id = :id'
        );
        $stmt->execute(['tenant_id' => $this->tenantId, 'id' => $contactId]);
        return $stmt->fetch() ?: null;
    }

    public function create(string $name, ?string $email = null, ?string $phone = null, string $temperature = 'cold'): int
    {
        if (trim($name) === '' || mb_strlen($name) > 180) {
            throw new InvalidArgumentException('Nome inválido');
        }
        if ($email !== null && (strlen($email) > 254 || !filter_var($email, FILTER_VALIDATE_EMAIL))) {
            throw new InvalidArgumentException('E-mail inválido');
        }
        if ($phone !== null && mb_strlen($phone) > 40) {
            throw new InvalidArgumentException('Telefone inválido');
        }
        if (!in_array($temperature, ['cold', 'warm', 'hot'], true)) {
            throw new InvalidArgumentException('Temperatura inválida');
        }
        $stmt = $this->db->prepare(
            'INSERT INTO contacts (tenant_id, name, email, phone, temperature)
             VALUES (:tenant_id, :name, :email, :phone, :temperature)'
        );
        $stmt->execute([
            'tenant_id' => $this->tenantId,
            'name' => trim($name),
            'email' => $email,
            'phone' => $phone,
            'temperature' => $temperature,
        ]);
        return (int) $this->db->lastInsertId();
    }
}
