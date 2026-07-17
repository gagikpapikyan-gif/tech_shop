<?php

namespace App\Controller;

use App\Repository\ProductRepository;
use App\Repository\UserRepository;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

class AdminController extends AbstractController
{
    #[Route('/admin', name: 'app_admin_dashboard')]
    public function index(UserRepository $userRepository, ProductRepository $productRepository): Response
    {
        // Հաշվում ենք օգտատերերի և ապրանքների ընդհանուր քանակը բազայից
        $totalUsers = $userRepository->count([]);
        $totalProducts = $productRepository->count([]);

        return $this->render('admin/index.html.twig', [
            'total_users' => $totalUsers,
            'total_products' => $totalProducts,
        ]);
    }
}